import 'package:flutter/foundation.dart';

typedef LogSink = void Function(String message);

final class SafeLogger {
  SafeLogger({this.enabled = true, LogSink? sink}) : _sink = sink ?? debugPrint;

  final bool enabled;
  final LogSink _sink;

  static const _sensitiveKeys = {
    'authorization',
    'cookie',
    'set-cookie',
    'mobile',
    'mobile_number',
    'mobilenumber',
    'username',
    'user_id',
    'userid',
    'roles',
    'session_id',
    'sessionid',
    'device_id',
    'deviceid',
    'device_name',
    'user-agent',
    'access_token',
    'accesstoken',
    'refresh_token',
    'refreshtoken',
    'token',
    'pin',
    'otp',
    'nid',
    'cif',
    'account_number',
    'wallet_number',
    'kyc_image',
    'biometric_private_key',
  };

  Object? redact(Object? value, {String? key}) {
    final normalizedKey = key
        ?.replaceAll('-', '_')
        .replaceAll(RegExp(r'(?<=[a-z])(?=[A-Z])'), '_')
        .toLowerCase();
    if (normalizedKey != null &&
        (_sensitiveKeys.contains(key!.toLowerCase()) ||
            _sensitiveKeys.contains(normalizedKey))) {
      return '[REDACTED]';
    }
    if (value is Map) {
      return value.map(
        (mapKey, mapValue) =>
            MapEntry(mapKey, redact(mapValue, key: mapKey.toString())),
      );
    }
    if (value is Iterable) return value.map(redact).toList();
    return value;
  }

  void event(String name, {Map<String, Object?> fields = const {}}) {
    if (!enabled) return;
    _sink('$name ${redact(fields)}');
  }
}
