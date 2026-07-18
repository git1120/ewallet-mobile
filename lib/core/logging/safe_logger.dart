import 'package:flutter/foundation.dart';

typedef LogSink = void Function(String message);

final class SafeLogger {
  SafeLogger({this.enabled = true, LogSink? sink}) : _sink = sink ?? debugPrint;

  final bool enabled;
  final LogSink _sink;

  static const _sensitiveKeys = {
    'authorization',
    'access_token',
    'refresh_token',
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
    if (key != null && _sensitiveKeys.contains(key.toLowerCase())) {
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
