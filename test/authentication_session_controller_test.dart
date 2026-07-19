import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iba_ewallet/app/session/access_token_store.dart';
import 'package:iba_ewallet/app/session/authentication_session_manager.dart';
import 'package:iba_ewallet/app/session/refresh_coordinator.dart';
import 'package:iba_ewallet/core/api/api_client.dart';
import 'package:iba_ewallet/core/config/environment.dart';
import 'package:iba_ewallet/core/error/app_failure.dart';
import 'package:iba_ewallet/core/logging/safe_logger.dart';
import 'package:iba_ewallet/core/storage/secure_storage.dart';
import 'package:iba_ewallet/features/authentication/application/authentication_controller.dart';
import 'package:iba_ewallet/features/authentication/domain/authentication_repository.dart';
import 'package:iba_ewallet/features/authentication/domain/authentication_session.dart';
import 'package:iba_ewallet/features/authentication/domain/authentication_state.dart';

import 'test_helpers.dart';

void main() {
  const firstSession = AuthenticationSession(
    accessToken: 'access-one',
    refreshToken: 'refresh-one',
    tokenType: 'Bearer',
    sessionId: '123e4567-e89b-42d3-a456-426614174000',
  );
  const rotatedSession = AuthenticationSession(
    accessToken: 'access-two',
    refreshToken: 'refresh-two',
    tokenType: 'Bearer',
    sessionId: '223e4567-e89b-42d3-a456-426614174001',
  );

  group('secure rotating session manager', () {
    test(
      'persists only refresh/session material and keeps access in memory',
      () async {
        final store = MemorySecureStore();
        final tokens = AccessTokenStore();
        final manager = AuthenticationSessionManager(
          secureStore: store,
          accessTokens: tokens,
          refreshCoordinator: RefreshCoordinator(),
          repository: FakeAuthenticationRepository(),
        );
        await manager.establish(firstSession);
        expect(tokens.accessToken, 'access-one');
        expect(store.values[SecretKeys.refreshToken], 'refresh-one');
        expect(store.values[SecretKeys.sessionId], firstSession.sessionId);
        expect(store.values.values, isNot(contains('access-one')));
      },
    );

    test(
      'rotates once for concurrent callers and replaces the old token',
      () async {
        final store = MemorySecureStore()
          ..values[SecretKeys.refreshToken] = 'refresh-one'
          ..values[SecretKeys.sessionId] = firstSession.sessionId;
        final tokens = AccessTokenStore();
        final repository = FakeAuthenticationRepository();
        final completer = Completer<AuthenticationSession>();
        repository.refreshCompleter = completer;
        final manager = AuthenticationSessionManager(
          secureStore: store,
          accessTokens: tokens,
          refreshCoordinator: RefreshCoordinator(),
          repository: repository,
        );
        final first = manager.refresh();
        final second = manager.refresh();
        expect(identical(first, second), isTrue);
        await Future<void>.delayed(Duration.zero);
        expect(repository.refreshCalls, 1);
        completer.complete(rotatedSession);
        expect(await first, 'access-two');
        expect(await second, 'access-two');
        expect(repository.lastRefreshToken, 'refresh-one');
        expect(store.values[SecretKeys.refreshToken], 'refresh-two');
        expect(tokens.accessToken, 'access-two');
      },
    );

    test('logout generation prevents stale refresh overwrite', () async {
      final store = MemorySecureStore()
        ..values[SecretKeys.refreshToken] = 'refresh-one'
        ..values[SecretKeys.sessionId] = firstSession.sessionId;
      final tokens = AccessTokenStore();
      final repository = FakeAuthenticationRepository();
      final completer = Completer<AuthenticationSession>();
      repository.refreshCompleter = completer;
      final manager = AuthenticationSessionManager(
        secureStore: store,
        accessTokens: tokens,
        refreshCoordinator: RefreshCoordinator(),
        repository: repository,
      );
      final refresh = manager.refresh();
      await manager.clear();
      completer.complete(rotatedSession);
      expect(await refresh, isNull);
      expect(tokens.accessToken, isNull);
      expect(store.values, isEmpty);
    });

    test('corrupt partial secure state is cleared', () async {
      final store = MemorySecureStore()
        ..values[SecretKeys.refreshToken] = 'orphan';
      final manager = AuthenticationSessionManager(
        secureStore: store,
        accessTokens: AccessTokenStore(),
        refreshCoordinator: RefreshCoordinator(),
        repository: FakeAuthenticationRepository(),
      );
      expect(await manager.storedRefreshToken(), isNull);
      expect(store.values, isEmpty);
    });
  });

  group('deterministic authentication controller', () {
    ({
      AuthenticationController controller,
      FakeAuthenticationRepository repository,
      MemorySecureStore store,
      AccessTokenStore tokens,
    })
    build() {
      final repository = FakeAuthenticationRepository()
        ..loginResult = firstSession
        ..refreshResult = rotatedSession;
      final store = MemorySecureStore();
      final tokens = AccessTokenStore();
      final coordinator = RefreshCoordinator();
      final manager = AuthenticationSessionManager(
        secureStore: store,
        accessTokens: tokens,
        refreshCoordinator: coordinator,
        repository: repository,
      );
      final apiClient = ApiClient(
        config: EnvironmentConfig.forEnvironment(AppEnvironment.development),
        accessTokenSource: tokens,
        refreshCoordinator: coordinator,
        logger: SafeLogger(enabled: false),
        dio: Dio(),
      );
      return (
        controller: AuthenticationController(
          repository: repository,
          sessionManager: manager,
          apiClient: apiClient,
        ),
        repository: repository,
        store: store,
        tokens: tokens,
      );
    }

    test(
      'starts checking, then restores no session as unauthenticated',
      () async {
        final fixture = build();
        expect(fixture.controller.state.session, SessionStatus.bootstrapping);
        await fixture.controller.restore();
        expect(fixture.controller.state.session, SessionStatus.unauthenticated);
      },
    );

    test(
      'login confirms session, persists securely, and blocks duplicates',
      () async {
        final fixture = build();
        await fixture.controller.restore();
        fixture.controller.continueToPin();
        final first = fixture.controller.login(
          mobileNumber: '0700000000',
          pin: '123456',
        );
        final duplicate = fixture.controller.login(
          mobileNumber: '0700000000',
          pin: '654321',
        );
        await Future.wait([first, duplicate]);
        expect(fixture.repository.loginCalls, 1);
        expect(fixture.controller.state.session, SessionStatus.authenticated);
        expect(
          fixture.store.values[SecretKeys.refreshToken],
          firstSession.refreshToken,
        );
      },
    );

    test(
      'invalid credentials, offline, and restrictions map precisely',
      () async {
        final fixture = build();
        await fixture.controller.restore();
        fixture.controller.continueToPin();
        fixture.repository.loginFailure = const AppFailure(
          kind: FailureKind.authentication,
          messageKey: 'invalidCredentials',
          code: 'PIN_INVALID',
        );
        await fixture.controller.login(
          mobileNumber: '0700000000',
          pin: '123456',
        );
        expect(
          fixture.controller.state.loginStage,
          LoginStage.invalidCredentials,
        );

        fixture.repository.loginFailure = const AppFailure(
          kind: FailureKind.network,
          messageKey: 'networkError',
        );
        await fixture.controller.login(
          mobileNumber: '0700000000',
          pin: '123456',
        );
        expect(
          fixture.controller.state.request,
          AuthenticationRequestStatus.offline,
        );

        fixture.repository.loginFailure = const AppFailure(
          kind: FailureKind.accountRestriction,
          messageKey: 'accountRestricted',
          code: 'USER_SUSPENDED',
        );
        await fixture.controller.login(
          mobileNumber: '0700000000',
          pin: '123456',
        );
        expect(fixture.controller.state.session, SessionStatus.terminal);
        expect(
          fixture.controller.state.restriction,
          AccountRestriction.suspended,
        );
      },
    );

    test('PIN lock is non-countdown form state', () async {
      final fixture = build();
      await fixture.controller.restore();
      fixture.controller.continueToPin();
      fixture.repository.loginFailure = const AppFailure(
        kind: FailureKind.accountRestriction,
        messageKey: 'accountLocked',
        code: 'PIN_LOCKED',
      );
      await fixture.controller.login(mobileNumber: '0700000000', pin: '123456');
      expect(fixture.controller.state.loginStage, LoginStage.temporarilyLocked);
      expect(fixture.controller.state.session, SessionStatus.unauthenticated);
    });

    test(
      'restore rotates and confirms; terminal refresh clears state',
      () async {
        final fixture = build();
        fixture.store.values
          ..[SecretKeys.refreshToken] = firstSession.refreshToken
          ..[SecretKeys.sessionId] = firstSession.sessionId;
        await fixture.controller.restore();
        expect(fixture.controller.state.session, SessionStatus.authenticated);
        expect(fixture.repository.refreshCalls, 1);

        await fixture.controller.logout();
        expect(fixture.controller.state.session, SessionStatus.unauthenticated);
        expect(fixture.store.values, isEmpty);
        expect(fixture.tokens.accessToken, isNull);
      },
    );

    test('backend logout failure still completes local cleanup', () async {
      final fixture = build();
      await fixture.controller.restore();
      fixture.controller.continueToPin();
      await fixture.controller.login(mobileNumber: '0700000000', pin: '123456');
      fixture.repository.logoutFailure = Exception('network');
      await fixture.controller.logout();
      expect(fixture.controller.state.session, SessionStatus.unauthenticated);
      expect(fixture.store.values, isEmpty);
      expect(fixture.repository.logoutCalls, 1);
    });
  });
}

final class FakeAuthenticationRepository implements AuthenticationRepository {
  AuthenticationSession? loginResult;
  AuthenticationSession? refreshResult;
  Object? loginFailure;
  Object? refreshFailure;
  Object? logoutFailure;
  Completer<AuthenticationSession>? refreshCompleter;
  bool confirmationResult = true;
  int loginCalls = 0;
  int refreshCalls = 0;
  int logoutCalls = 0;
  String? lastRefreshToken;

  @override
  Future<bool> confirmSession({
    required String sessionId,
    CancelToken? cancelToken,
  }) async => confirmationResult;

  @override
  Future<AuthenticationSession> login({
    required String mobileNumber,
    required String pin,
    CancelToken? cancelToken,
  }) async {
    loginCalls++;
    if (loginFailure case final failure?) throw failure;
    return loginResult!;
  }

  @override
  Future<void> logout({CancelToken? cancelToken}) async {
    logoutCalls++;
    if (logoutFailure case final failure?) throw failure;
  }

  @override
  Future<AuthenticationSession> refresh({
    required String refreshToken,
    CancelToken? cancelToken,
  }) async {
    refreshCalls++;
    lastRefreshToken = refreshToken;
    if (refreshFailure case final failure?) throw failure;
    return refreshCompleter?.future ?? Future.value(refreshResult!);
  }
}
