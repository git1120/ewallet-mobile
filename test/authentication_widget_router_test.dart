import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iba_ewallet/app/app.dart';
import 'package:iba_ewallet/app/session/access_token_store.dart';
import 'package:iba_ewallet/app/session/authentication_session_manager.dart';
import 'package:iba_ewallet/app/session/refresh_coordinator.dart';
import 'package:iba_ewallet/core/api/api_client.dart';
import 'package:iba_ewallet/core/config/environment.dart';
import 'package:iba_ewallet/core/error/app_failure.dart';
import 'package:iba_ewallet/core/logging/safe_logger.dart';
import 'package:iba_ewallet/core/storage/secure_storage.dart';
import 'package:iba_ewallet/design_system/inputs/iba_pin_keypad.dart';
import 'package:iba_ewallet/features/authentication/application/authentication_controller.dart';
import 'package:iba_ewallet/features/authentication/domain/authentication_repository.dart';
import 'package:iba_ewallet/features/authentication/domain/authentication_session.dart';
import 'package:iba_ewallet/features/authentication/domain/authentication_state.dart';
import 'package:iba_ewallet/features/authentication/presentation/authentication_login_page.dart';

import 'test_helpers.dart';

void main() {
  const uuid = '123e4567-e89b-42d3-a456-426614174000';
  const session = AuthenticationSession(
    accessToken: 'access',
    refreshToken: 'refresh',
    tokenType: 'Bearer',
    sessionId: uuid,
  );

  Future<AuthenticationController> controllerFor(
    WidgetRepository repository,
  ) async {
    final tokens = AccessTokenStore();
    final coordinator = RefreshCoordinator();
    final manager = AuthenticationSessionManager(
      secureStore: MemorySecureStore(),
      accessTokens: tokens,
      refreshCoordinator: coordinator,
      repository: repository,
    );
    final controller = AuthenticationController(
      repository: repository,
      sessionManager: manager,
      apiClient: ApiClient(
        config: EnvironmentConfig.forEnvironment(AppEnvironment.development),
        accessTokenSource: tokens,
        refreshCoordinator: coordinator,
        logger: SafeLogger(enabled: false),
        dio: Dio(),
      ),
    );
    await controller.restore();
    return controller;
  }

  testWidgets('approved mobile entry validates exact ten digits', (
    tester,
  ) async {
    final controller = await controllerFor(WidgetRepository(session));
    await tester.pumpWidget(
      testApp(
        AuthenticationLoginPage(controller: controller),
        wrapInScaffold: false,
      ),
    );
    final continueButton = find.byKey(const ValueKey('auth-continue'));
    expect(
      tester
          .widget<FilledButton>(
            find.descendant(
              of: continueButton,
              matching: find.byType(FilledButton),
            ),
          )
          .onPressed,
      isNull,
    );
    await tester.enterText(
      find.byKey(const ValueKey('auth-mobile-field')),
      '070123456',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(find.text('Enter a valid 10-digit mobile number.'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('auth-mobile-field')),
      '0701234567',
    );
    await tester.pump();
    await tester.tap(continueButton);
    await tester.pump();
    expect(find.text('Enter your PIN'), findsOneWidget);
    expect(find.byType(IbaPinKeypad), findsOneWidget);
  });

  testWidgets('six-digit keypad is obscured, deletes, and submits once', (
    tester,
  ) async {
    final repository = WidgetRepository(session);
    final controller = await controllerFor(repository);
    await tester.pumpWidget(
      testApp(
        AuthenticationLoginPage(controller: controller),
        wrapInScaffold: false,
      ),
    );
    await tester.enterText(
      find.byKey(const ValueKey('auth-mobile-field')),
      '0701234567',
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('auth-continue')));
    await tester.pump();

    for (final digit in const ['1', '2', '3', '4', '5']) {
      await tester.tap(find.text(digit));
    }
    await tester.pump();
    final deleteButton = find.ancestor(
      of: find.byIcon(Icons.backspace_outlined),
      matching: find.byType(FilledButton),
    );
    await tester.ensureVisible(deleteButton);
    await tester.tap(deleteButton);
    await tester.pump();
    expect(
      tester.widget<IbaPinKeypad>(find.byType(IbaPinKeypad)).enteredDigits,
      4,
    );
    await tester.tap(find.text('5'));
    await tester.tap(find.text('6'));
    await tester.pumpAndSettle();
    expect(repository.loginCalls, 1);
    expect(controller.state.session, SessionStatus.authenticated);
    final semantics = tester.getSemantics(
      find.byKey(const ValueKey('auth-pin-keypad')),
    );
    expect(semantics.label, contains('Secure 6-digit PIN keypad'));
    expect(semantics.value, isNot(contains('123456')));
  });

  testWidgets('invalid credentials clear PIN and show non-enumerating error', (
    tester,
  ) async {
    final repository = WidgetRepository(session)
      ..failure = const AppFailure(
        kind: FailureKind.authentication,
        messageKey: 'invalidCredentials',
        code: 'PIN_INVALID',
      );
    final controller = await controllerFor(repository);
    await tester.pumpWidget(
      testApp(
        AuthenticationLoginPage(controller: controller),
        wrapInScaffold: false,
      ),
    );
    await tester.enterText(
      find.byKey(const ValueKey('auth-mobile-field')),
      '0701234567',
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('auth-continue')));
    await tester.pump();
    for (final digit in const ['1', '2', '3', '4', '5', '6']) {
      await tester.tap(find.text(digit));
    }
    await tester.pumpAndSettle();
    expect(
      find.text('The mobile number or PIN is incorrect. Try again.'),
      findsOneWidget,
    );
    expect(
      tester.widget<IbaPinKeypad>(find.byType(IbaPinKeypad)).enteredDigits,
      0,
    );
  });

  testWidgets('Dari/Pashto RTL and 200 percent text remain usable', (
    tester,
  ) async {
    for (final locale in const [Locale('fa'), Locale('ps')]) {
      final controller = await controllerFor(WidgetRepository(session));
      await tester.pumpWidget(
        testApp(
          AuthenticationLoginPage(controller: controller),
          locale: locale,
          textScale: 2,
          wrapInScaffold: false,
        ),
      );
      await tester.pump();
      expect(
        Directionality.of(
          tester.element(find.byKey(const ValueKey('auth-mobile-field'))),
        ),
        TextDirection.rtl,
      );
      expect(tester.takeException(), isNull);
    }
  });

  group('router guards and restoration', () {
    testWidgets('bootstrap holds then unauthenticated route is login', (
      tester,
    ) async {
      await tester.pumpWidget(
        IbaApp(
          config: EnvironmentConfig.forEnvironment(AppEnvironment.development),
          preferences: MemoryPreferences(),
          secureStore: MemorySecureStore(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Your secure session is active'), findsNothing);
    });

    testWidgets(
      'rotated restoration reaches protected route and logout returns',
      (tester) async {
        final store = MemorySecureStore()
          ..values[SecretKeys.refreshToken] = 'old-refresh'
          ..values[SecretKeys.sessionId] = uuid;
        final dio = Dio()
          ..httpClientAdapter = RouteAdapter((request) {
            if (request.path.endsWith('/refresh')) {
              return (200, jwtEnvelope(uuid));
            }
            if (request.path.endsWith('/devices')) {
              return (
                200,
                {
                  'success': true,
                  'data': [
                    {'deviceSessionId': uuid, 'status': 'ACTIVE'},
                  ],
                },
              );
            }
            return (200, {'success': true, 'data': null});
          });
        await tester.pumpWidget(
          IbaApp(
            config: EnvironmentConfig.forEnvironment(
              AppEnvironment.development,
            ),
            preferences: MemoryPreferences(),
            secureStore: store,
            dio: dio,
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Your secure session is active'), findsOneWidget);
        await tester.tap(find.text('Log out'));
        await tester.pumpAndSettle();
        expect(find.text('Welcome back'), findsOneWidget);
        expect(store.values, isEmpty);
      },
    );

    testWidgets('terminal refresh redirects once to session recovery', (
      tester,
    ) async {
      final store = MemorySecureStore()
        ..values[SecretKeys.refreshToken] = 'expired-refresh'
        ..values[SecretKeys.sessionId] = uuid;
      final dio = Dio()
        ..httpClientAdapter = RouteAdapter(
          (_) => (
            401,
            {
              'success': false,
              'error': {'code': 'REFRESH_TOKEN_EXPIRED'},
              'meta': {'traceId': 'trace'},
            },
          ),
        );
      await tester.pumpWidget(
        IbaApp(
          config: EnvironmentConfig.forEnvironment(AppEnvironment.development),
          preferences: MemoryPreferences(),
          secureStore: store,
          dio: dio,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Session expired'), findsOneWidget);
      expect(find.text('Your secure session is active'), findsNothing);
      expect(store.values, isEmpty);
    });
  });
}

Map<String, Object?> jwtEnvelope(String uuid) => {
  'success': true,
  'data': {
    'token': 'new-access',
    'refreshToken': 'new-refresh',
    'type': 'Bearer',
    'id': uuid,
    'username': 'user',
    'roles': ['ROLE_USER'],
    'deviceSessionId': uuid,
  },
};

final class WidgetRepository implements AuthenticationRepository {
  WidgetRepository(this.session);

  final AuthenticationSession session;
  Object? failure;
  int loginCalls = 0;

  @override
  Future<bool> confirmSession({
    required String sessionId,
    CancelToken? cancelToken,
  }) async => true;

  @override
  Future<AuthenticationSession> login({
    required String mobileNumber,
    required String pin,
    CancelToken? cancelToken,
  }) async {
    loginCalls++;
    if (failure case final value?) throw value;
    return session;
  }

  @override
  Future<void> logout({CancelToken? cancelToken}) async {}

  @override
  Future<AuthenticationSession> refresh({
    required String refreshToken,
    CancelToken? cancelToken,
  }) async => session;
}

typedef RouteResponse = (int status, Object? body);

final class RouteAdapter implements HttpClientAdapter {
  RouteAdapter(this.responder);

  final RouteResponse Function(RequestOptions request) responder;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final (status, body) = responder(options);
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        'x-trace-id': ['trace'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
