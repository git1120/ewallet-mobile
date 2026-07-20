import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iba_ewallet/app/session/access_token_store.dart';
import 'package:iba_ewallet/app/session/refresh_coordinator.dart';
import 'package:iba_ewallet/core/api/api_client.dart';
import 'package:iba_ewallet/core/config/environment.dart';
import 'package:iba_ewallet/core/error/app_failure.dart';
import 'package:iba_ewallet/core/logging/safe_logger.dart';
import 'package:iba_ewallet/features/authentication/data/authentication_api.dart';
import 'package:iba_ewallet/features/authentication/data/dto/authentication_dto.dart';

void main() {
  const uuid = '123e4567-e89b-42d3-a456-426614174000';
  late AccessTokenStore tokens;
  late RecordingAdapter adapter;
  late AuthenticationApi api;

  Map<String, Object?> jwtEnvelope() => {
    'success': true,
    'data': {
      'token': 'access',
      'refreshToken': 'refresh',
      'type': 'Bearer',
      'id': uuid,
      'username': 'user',
      'roles': ['ROLE_USER'],
      'deviceSessionId': uuid,
      'deviceId': uuid,
    },
  };

  setUp(() {
    tokens = AccessTokenStore();
    adapter = RecordingAdapter((_) => (200, jwtEnvelope()));
    final dio = Dio()..httpClientAdapter = adapter;
    api = AuthenticationApi(
      ApiClient(
        config: EnvironmentConfig.forEnvironment(AppEnvironment.development),
        accessTokenSource: tokens,
        refreshCoordinator: RefreshCoordinator(),
        logger: SafeLogger(enabled: false),
        dio: dio,
      ),
    );
  });

  test('login uses exact path/body/headers without authorization', () async {
    await api.login(
      const LoginRequestDto(mobileNumber: '0700000000', pin: '246810'),
    );
    final request = adapter.requests.single;
    expect(request.method, 'POST');
    expect(request.path, '/api/v1/auth/login');
    expect(request.data, {'mobileNumber': '0700000000', 'pin': '246810'});
    expect(request.headers['Accept'], 'application/json');
    expect(request.headers['content-type'], contains('application/json'));
    expect(request.headers['Authorization'], isNull);
    expect(request.headers['X-Trace-Id'], isNotEmpty);
    expect(request.headers.keys, isNot(contains('X-Device-Id')));
  });

  test('refresh sends only rotating credential and cannot recurse', () async {
    await api.refresh(const RefreshRequestDto(refreshToken: 'old-refresh'));
    final request = adapter.requests.single;
    expect(request.path, '/api/v1/auth/refresh');
    expect(request.data, {'refreshToken': 'old-refresh'});
    expect(request.extra[ApiRequestOptions.skipRefresh], isTrue);
    expect(request.headers['Authorization'], isNull);
  });

  test('devices and logout use memory bearer token and exact routes', () async {
    tokens.set('memory-access');
    adapter.responder = (request) => request.path.endsWith('/devices')
        ? (
            200,
            {
              'success': true,
              'data': [
                {'deviceSessionId': uuid, 'status': 'ACTIVE'},
              ],
            },
          )
        : (200, {'success': true, 'data': null});
    expect((await api.devices()).single.status, 'ACTIVE');
    await api.logout();
    expect(adapter.requests[0].path, '/api/v1/auth/devices');
    expect(adapter.requests[1].path, '/api/v1/auth/logout');
    expect(adapter.requests[1].data, isNull);
    expect(
      adapter.requests.every(
        (request) => request.headers['Authorization'] == 'Bearer memory-access',
      ),
      isTrue,
    );
  });

  test(
    'API surfaces typed nested backend failure without raw payload',
    () async {
      adapter.responder = (_) => (
        401,
        {
          'success': false,
          'message': 'raw diagnostic',
          'error': {'code': 'PIN_INVALID'},
          'meta': {'traceId': 'body-trace'},
        },
      );
      try {
        await api.login(
          const LoginRequestDto(mobileNumber: '0700000000', pin: '246810'),
        );
        fail('Expected DioException');
      } on DioException catch (error) {
        final failure = error.error! as AppFailure;
        expect(failure.kind, FailureKind.authentication);
        expect(failure.traceId, 'server-trace');
        expect(failure.toString(), isNot(contains('raw diagnostic')));
      }
    },
  );
}

typedef AdapterResponse = (int status, Object? body);

final class RecordingAdapter implements HttpClientAdapter {
  RecordingAdapter(this.responder);

  AdapterResponse Function(RequestOptions request) responder;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final (status, body) = responder(options);
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        'x-trace-id': ['server-trace'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
