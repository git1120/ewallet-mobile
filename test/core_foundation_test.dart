import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:iba_ewallet/app/session/refresh_coordinator.dart';
import 'package:iba_ewallet/core/config/environment.dart';
import 'package:iba_ewallet/core/logging/safe_logger.dart';
import 'package:iba_ewallet/core/security/idempotency_key.dart';
import 'package:iba_ewallet/core/utils/formatters.dart';

void main() {
  group('environment', () {
    test('development enables diagnostics and gallery', () {
      final config = EnvironmentConfig.forEnvironment(
        AppEnvironment.development,
      );
      expect(config.enableLogging, isTrue);
      expect(config.enableComponentGallery, isTrue);
    });

    test('production rejects non-production URLs', () {
      expect(
        () => EnvironmentConfig.forEnvironment(
          AppEnvironment.production,
          apiBaseUrl: 'http://localhost:8080',
        ),
        throwsStateError,
      );
    });
  });

  test('amount, phone, and account formatting are safe', () {
    expect(IbaFormatters('en').amount(12.5), contains('12.50'));
    expect(IbaFormatters.phone('0701234567'), '+93 701 234 567');
    expect(IbaFormatters.maskAccount('1234567890'), '•••• 7890');
  });

  test('logger recursively redacts sensitive fields', () {
    final messages = <String>[];
    SafeLogger(sink: messages.add).event(
      'request',
      fields: {
        'authorization': 'Bearer secret',
        'nested': {'pin': '1234'},
        'safe': 'value',
      },
    );
    expect(messages.single, isNot(contains('secret')));
    expect(messages.single, isNot(contains('1234')));
    expect(messages.single, contains('value'));
  });

  test('idempotency keys are unique UUIDs', () {
    const generator = UuidIdempotencyKeyGenerator();
    final first = generator.generate();
    final second = generator.generate();
    expect(first, isNot(second));
    expect(
      RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      ).hasMatch(first),
      isTrue,
    );
  });

  test('refresh coordinator shares one concurrent operation', () async {
    final coordinator = RefreshCoordinator();
    final completer = Completer<String?>();
    var calls = 0;
    Future<String?> operation() {
      calls++;
      return completer.future;
    }

    final first = coordinator.refresh(operation);
    final second = coordinator.refresh(operation);
    expect(identical(first, second), isTrue);
    expect(calls, 1);
    completer.complete('token');
    expect(await first, 'token');
  });
}
