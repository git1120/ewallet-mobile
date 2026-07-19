import 'package:iba_ewallet/core/error/app_failure.dart';
import 'package:iba_ewallet/features/authentication/domain/authentication_session.dart';

final class LoginRequestDto {
  const LoginRequestDto({required this.mobileNumber, required this.pin});

  final String mobileNumber;
  final String pin;

  Map<String, Object> toJson() => {'mobileNumber': mobileNumber, 'pin': pin};

  @override
  String toString() => 'LoginRequestDto([REDACTED])';
}

final class RefreshRequestDto {
  const RefreshRequestDto({required this.refreshToken});

  final String refreshToken;

  Map<String, Object> toJson() => {'refreshToken': refreshToken};

  @override
  String toString() => 'RefreshRequestDto([REDACTED])';
}

final class JwtResponseDto {
  const JwtResponseDto({
    required this.token,
    required this.refreshToken,
    required this.type,
    required this.userId,
    required this.username,
    required this.roles,
    required this.deviceSessionId,
  });

  factory JwtResponseDto.fromEnvelope(Object? json) {
    final envelope = _requiredMap(json, 'response');
    if (envelope['success'] != true) {
      throw const MalformedAuthenticationResponse('Unsuccessful envelope');
    }
    final data = _requiredMap(envelope['data'], 'data');
    final rolesValue = data['roles'];
    if (rolesValue != null &&
        (rolesValue is! List || rolesValue.any((role) => role is! String))) {
      throw const MalformedAuthenticationResponse('Invalid roles');
    }
    final deviceSessionId = _requiredUuid(
      data['deviceSessionId'] ?? data['deviceId'],
      'deviceSessionId',
    );
    return JwtResponseDto(
      token: _requiredString(data['token'], 'token'),
      refreshToken: _requiredString(data['refreshToken'], 'refreshToken'),
      type: _requiredString(data['type'], 'type'),
      userId: _requiredUuid(data['id'], 'id'),
      username: _requiredString(data['username'], 'username'),
      roles: rolesValue == null
          ? const []
          : List<String>.from(rolesValue as List),
      deviceSessionId: deviceSessionId,
    );
  }

  final String token;
  final String refreshToken;
  final String type;
  final String userId;
  final String username;
  final List<String> roles;
  final String deviceSessionId;

  AuthenticationSession toDomain() => AuthenticationSession(
    accessToken: token,
    refreshToken: refreshToken,
    tokenType: type,
    sessionId: deviceSessionId,
  );

  @override
  String toString() => 'JwtResponseDto(credentials: [REDACTED])';
}

final class DeviceSessionDto {
  const DeviceSessionDto({required this.sessionId, required this.status});

  factory DeviceSessionDto.fromJson(Object? json) {
    final map = _requiredMap(json, 'device session');
    return DeviceSessionDto(
      sessionId: _requiredUuid(
        map['deviceSessionId'] ?? map['deviceId'],
        'deviceSessionId',
      ),
      status: _requiredString(map['status'], 'status'),
    );
  }

  final String sessionId;
  final String status;
}

List<DeviceSessionDto> parseDeviceSessions(Object? json) {
  final envelope = _requiredMap(json, 'response');
  if (envelope['success'] != true || envelope['data'] is! List) {
    throw const MalformedAuthenticationResponse(
      'Invalid device-session envelope',
    );
  }
  return [
    for (final item in envelope['data'] as List)
      DeviceSessionDto.fromJson(item),
  ];
}

final class MalformedAuthenticationResponse extends AppFailure {
  const MalformedAuthenticationResponse(this.reason)
    : super(kind: FailureKind.unknown, messageKey: 'genericError');

  final String reason;

  @override
  String toString() => 'MalformedAuthenticationResponse($reason)';
}

Map<Object?, Object?> _requiredMap(Object? value, String field) {
  if (value is! Map) {
    throw MalformedAuthenticationResponse('Invalid $field');
  }
  return value;
}

String _requiredString(Object? value, String field) {
  if (value is! String || value.trim().isEmpty) {
    throw MalformedAuthenticationResponse('Invalid $field');
  }
  return value;
}

String _requiredUuid(Object? value, String field) {
  final text = _requiredString(value, field);
  final uuid = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
  );
  if (!uuid.hasMatch(text)) {
    throw MalformedAuthenticationResponse('Invalid $field');
  }
  return text;
}
