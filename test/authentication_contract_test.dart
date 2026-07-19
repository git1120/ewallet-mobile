import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iba_ewallet/core/api/api_client.dart';
import 'package:iba_ewallet/core/config/environment.dart';
import 'package:iba_ewallet/core/error/app_failure.dart';
import 'package:iba_ewallet/core/logging/safe_logger.dart';
import 'package:iba_ewallet/features/authentication/data/dto/authentication_dto.dart';

void main() {
  const uuid = '123e4567-e89b-42d3-a456-426614174000';
  const replacementUuid = '223e4567-e89b-42d3-a456-426614174001';

  Map<String, Object?> envelope({
    String token = 'access-secret',
    String refreshToken = 'refresh-secret',
    String deviceSessionId = uuid,
  }) => {
    'success': true,
    'message': 'diagnostic only',
    'data': {
      'token': token,
      'refreshToken': refreshToken,
      'type': 'Bearer',
      'id': uuid,
      'username': '0700000000',
      'roles': ['ROLE_USER'],
      'deviceSessionId': deviceSessionId,
      'deviceId': deviceSessionId,
    },
    'meta': {'timeZone': 'Asia/Kabul'},
  };

  group('authentication DTO contract', () {
    test('parses exact login and rotating refresh envelopes', () {
      final login = JwtResponseDto.fromEnvelope(envelope());
      final refresh = JwtResponseDto.fromEnvelope(
        envelope(
          token: 'new-access',
          refreshToken: 'new-refresh',
          deviceSessionId: replacementUuid,
        ),
      );
      expect(login.type, 'Bearer');
      expect(login.deviceSessionId, uuid);
      expect(refresh.deviceSessionId, replacementUuid);
      expect(refresh.toDomain().refreshToken, 'new-refresh');
      expect(login.toString(), isNot(contains('access-secret')));
    });

    test('accepts deviceId alias and optional roles', () {
      final body = envelope();
      final data = body['data']! as Map<String, Object?>;
      data
        ..remove('deviceSessionId')
        ..remove('roles');
      final dto = JwtResponseDto.fromEnvelope(body);
      expect(dto.deviceSessionId, uuid);
      expect(dto.roles, isEmpty);
    });

    test('rejects missing tokens, malformed UUID, and failure envelope', () {
      final missing = envelope();
      (missing['data']! as Map<String, Object?>).remove('token');
      expect(
        () => JwtResponseDto.fromEnvelope(missing),
        throwsA(isA<MalformedAuthenticationResponse>()),
      );
      expect(
        () => JwtResponseDto.fromEnvelope(
          envelope(deviceSessionId: 'not-a-uuid'),
        ),
        throwsA(isA<MalformedAuthenticationResponse>()),
      );
      expect(
        () => JwtResponseDto.fromEnvelope({'success': false}),
        throwsA(isA<MalformedAuthenticationResponse>()),
      );
    });

    test('serializes only backend-supported login and refresh fields', () {
      expect(
        const LoginRequestDto(
          mobileNumber: '0700000000',
          pin: '123456',
        ).toJson(),
        {'mobileNumber': '0700000000', 'pin': '123456'},
      );
      expect(const RefreshRequestDto(refreshToken: 'secret').toJson(), {
        'refreshToken': 'secret',
      });
    });

    test('parses active device confirmation and rejects malformed list', () {
      final parsed = parseDeviceSessions({
        'success': true,
        'data': [
          {'deviceSessionId': uuid, 'status': 'ACTIVE'},
        ],
      });
      expect(parsed.single.sessionId, uuid);
      expect(
        () => parseDeviceSessions({'success': true, 'data': {}}),
        throwsA(isA<MalformedAuthenticationResponse>()),
      );
    });
  });

  group('backend failure envelope', () {
    DioException error({
      Object? data,
      int status = 401,
      Map<String, List<String>> headers = const {},
      DioExceptionType type = DioExceptionType.badResponse,
    }) {
      final options = RequestOptions(path: '/api/v1/auth/login');
      return DioException(
        requestOptions: options,
        type: type,
        response: Response<Object?>(
          requestOptions: options,
          statusCode: status,
          data: data,
          headers: Headers.fromMap(headers),
        ),
      );
    }

    test('reads nested code and header trace ID first', () {
      final failure = parseFailure(
        error(
          data: {
            'error': {'code': 'PIN_INVALID'},
            'meta': {'traceId': 'body-trace'},
          },
          headers: {
            'x-trace-id': ['header-trace'],
          },
        ),
      );
      expect(failure.kind, FailureKind.authentication);
      expect(failure.traceId, 'header-trace');
      expect(failure.httpStatus, 401);
    });

    test('uses body trace fallback and safe validation metadata', () {
      final failure = parseFailure(
        error(
          status: 400,
          data: {
            'error': {
              'code': 'VALIDATION_ERROR',
              'details': [
                {
                  'field': 'mobileNumber',
                  'code': 'INVALID',
                  'message': 'raw backend copy',
                  'invalidValue': '0700000000',
                },
              ],
            },
            'meta': {'traceId': 'body-trace'},
          },
        ),
      );
      expect(failure.traceId, 'body-trace');
      expect(failure.validationIssues.single.field, 'mobileNumber');
      expect(failure.toString(), isNot(contains('0700000000')));
      expect(failure.toString(), isNot(contains('raw backend copy')));
    });

    test('maps restrictions, session termination, rate and server states', () {
      for (final code in const [
        'PIN_LOCKED',
        'USER_SUSPENDED',
        'USER_LOCKED',
        'USER_CLOSED',
      ]) {
        expect(
          parseFailure(
            error(
              status: 403,
              data: {
                'error': {'code': code},
              },
            ),
          ).kind,
          FailureKind.accountRestriction,
        );
      }
      for (final code in const [
        'REFRESH_TOKEN_REUSED',
        'REFRESH_TOKEN_EXPIRED',
        'SESSION_REVOKED',
        'SESSION_EXPIRED',
      ]) {
        expect(
          parseFailure(
            error(
              data: {
                'error': {'code': code},
              },
            ),
          ).kind,
          FailureKind.session,
        );
      }
      expect(parseFailure(error(status: 429)).kind, FailureKind.rateLimited);
      expect(
        parseFailure(error(status: 503)).kind,
        FailureKind.serverUnavailable,
      );
    });

    test(
      'maps timeout, offline, cancellation, and malformed envelopes safely',
      () {
        expect(
          parseFailure(error(type: DioExceptionType.connectionTimeout)).kind,
          FailureKind.timeout,
        );
        expect(
          parseFailure(error(type: DioExceptionType.connectionError)).kind,
          FailureKind.network,
        );
        expect(
          parseFailure(error(type: DioExceptionType.cancel)).kind,
          FailureKind.cancelled,
        );
        expect(
          parseFailure(error(data: 'html')).kind,
          FailureKind.authentication,
        );
      },
    );
  });

  test('production rejects the deployed insecure development address', () {
    expect(
      () => EnvironmentConfig.forEnvironment(
        AppEnvironment.production,
        apiBaseUrl: 'https://74.118.81.141',
      ),
      throwsStateError,
    );
    expect(
      EnvironmentConfig.forEnvironment(AppEnvironment.development).dioBaseUrl,
      'http://74.118.81.141',
    );
  });

  test('diagnostics redact every authentication secret shape', () {
    final output = <String>[];
    SafeLogger(sink: output.add).event(
      'auth',
      fields: {
        'mobileNumber': '0700000000',
        'pin': '123456',
        'token': 'access',
        'refreshToken': 'refresh',
        'Authorization': 'Bearer access',
        'sessionId': uuid,
        'traceId': 'safe-trace',
      },
    );
    expect(output.single, contains('safe-trace'));
    for (final secret in const ['0700000000', '123456', uuid]) {
      expect(output.single, isNot(contains(secret)));
    }
    expect(output.single, isNot(contains('Bearer access')));
    expect(output.single, isNot(contains(': refresh,')));
  });
}
