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

    test('web development uses the same-origin proxy deterministically', () {
      final config = EnvironmentConfig.forEnvironment(
        AppEnvironment.development,
        isWeb: true,
      );
      expect(config.usesWebDevelopmentProxy, isTrue);
      expect(config.dioBaseUrl, isEmpty);
      expect(
        config.resolveApiEndpoint('/api/v1/auth/login').toString(),
        '/api/v1/auth/login',
      );
      expect(config.dioBaseUrl, isNot(contains('74.118.81.141')));
    });

    test(
      'native development keeps direct addressing and exact composition',
      () {
        final config = EnvironmentConfig.forEnvironment(
          AppEnvironment.development,
        );
        expect(config.usesWebDevelopmentProxy, isFalse);
        expect(config.dioBaseUrl, 'http://74.118.81.141');
        expect(
          config.resolveApiEndpoint('/api/v1/auth/login').toString(),
          'http://74.118.81.141/api/v1/auth/login',
        );
      },
    );

    test('explicit development overrides remain deterministic', () {
      final config = EnvironmentConfig.forEnvironment(
        AppEnvironment.development,
        apiBaseUrl: 'https://development-api.example/',
        isWeb: true,
      );
      expect(config.usesWebDevelopmentProxy, isFalse);
      expect(config.dioBaseUrl, 'https://development-api.example');
      expect(
        config.resolveApiEndpoint('/api/v1/auth/login').path,
        '/api/v1/auth/login',
      );
    });

    test('staging and production require secure remote URLs', () {
      for (final environment in const [
        AppEnvironment.staging,
        AppEnvironment.production,
      ]) {
        expect(
          () => EnvironmentConfig.forEnvironment(environment),
          throwsStateError,
        );
        for (final rejected in const [
          '/',
          'http://api.example.com',
          'https://localhost',
          'https://127.0.0.1',
          'https://[::1]',
          'https://74.118.81.141',
        ]) {
          expect(
            () => EnvironmentConfig.forEnvironment(
              environment,
              apiBaseUrl: rejected,
              isWeb: true,
            ),
            throwsA(anyOf(isA<ArgumentError>(), isA<StateError>())),
          );
        }
      }
      expect(
        EnvironmentConfig.forEnvironment(
          AppEnvironment.staging,
          apiBaseUrl: 'https://staging-api.example.com',
        ).dioBaseUrl,
        'https://staging-api.example.com',
      );
      expect(
        EnvironmentConfig.forEnvironment(
          AppEnvironment.production,
          apiBaseUrl: 'https://api.example.com',
        ).dioBaseUrl,
        'https://api.example.com',
      );
    });

    test('API composition rejects non-canonical endpoint paths', () {
      final config = EnvironmentConfig.forEnvironment(
        AppEnvironment.development,
      );
      for (final endpoint in const [
        'api/v1/auth/login',
        '//api/v1/auth/login',
        '/v1/auth/login',
      ]) {
        expect(() => config.resolveApiEndpoint(endpoint), throwsArgumentError);
      }
    });
  });

  test('amount, phone, and account formatting are safe', () {
    expect(IbaFormatters('en').amount(12.5), contains('12.50'));
    expect(IbaFormatters.phone('0702468109'), '+93 702 468 109');
    expect(IbaFormatters.maskAccount('9876543210'), '•••• 3210');
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
