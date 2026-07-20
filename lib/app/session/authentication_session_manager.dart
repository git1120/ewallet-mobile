import 'package:dio/dio.dart';
import 'package:iba_ewallet/app/session/access_token_store.dart';
import 'package:iba_ewallet/app/session/refresh_coordinator.dart';
import 'package:iba_ewallet/core/error/app_failure.dart';
import 'package:iba_ewallet/core/storage/secure_storage.dart';
import 'package:iba_ewallet/features/authentication/domain/authentication_repository.dart';
import 'package:iba_ewallet/features/authentication/domain/authentication_session.dart';

final class AuthenticationSessionManager {
  AuthenticationSessionManager({
    required SecureStore secureStore,
    required AccessTokenStore accessTokens,
    required RefreshCoordinator refreshCoordinator,
    required AuthenticationRepository repository,
  }) : _secureStore = secureStore,
       _accessTokens = accessTokens,
       _refreshCoordinator = refreshCoordinator,
       _repository = repository;

  final SecureStore _secureStore;
  final AccessTokenStore _accessTokens;
  final RefreshCoordinator _refreshCoordinator;
  final AuthenticationRepository _repository;

  int _generation = 0;
  String? _sessionId;

  String? get sessionId => _sessionId;
  int get generation => _generation;

  Future<String?> storedRefreshToken() async {
    try {
      final refresh = await _secureStore.read(SecretKeys.refreshToken);
      final session = await _secureStore.read(SecretKeys.sessionId);
      if (refresh == null && session == null) return null;
      if (refresh == null ||
          refresh.isEmpty ||
          session == null ||
          session.isEmpty) {
        await clear();
        return null;
      }
      _sessionId = session;
      return refresh;
    } catch (_) {
      await clear();
      throw const AppFailure(
        kind: FailureKind.storage,
        messageKey: 'genericError',
      );
    }
  }

  Future<void> establish(AuthenticationSession session) async {
    final operationGeneration = _generation;
    try {
      await _secureStore.write(SecretKeys.refreshToken, session.refreshToken);
      await _secureStore.write(SecretKeys.sessionId, session.sessionId);
      if (operationGeneration != _generation) {
        await _deleteStoredAuthentication();
        return;
      }
      _accessTokens.set(session.accessToken);
      _sessionId = session.sessionId;
    } catch (_) {
      await clear();
      throw const AppFailure(
        kind: FailureKind.storage,
        messageKey: 'genericError',
      );
    }
  }

  Future<String?> refresh() => _refreshCoordinator.refresh(() async {
    final operationGeneration = _generation;
    final oldToken = await storedRefreshToken();
    if (oldToken == null) return null;
    final session = await _repository.refresh(refreshToken: oldToken);
    if (operationGeneration != _generation) return null;
    await establish(session);
    return operationGeneration == _generation ? session.accessToken : null;
  });

  Future<bool> confirm({CancelToken? cancelToken}) async {
    final id = _sessionId;
    return id != null &&
        await _repository.confirmSession(
          sessionId: id,
          cancelToken: cancelToken,
        );
  }

  void invalidate() => _generation++;

  Future<void> clear() async {
    invalidate();
    _accessTokens.clear();
    _sessionId = null;
    await _deleteStoredAuthentication();
  }

  Future<void> _deleteStoredAuthentication() async {
    try {
      await _secureStore.delete(SecretKeys.refreshToken);
      await _secureStore.delete(SecretKeys.sessionId);
    } catch (_) {
      // Memory state is still cleared. The next restore repeats named cleanup.
    }
  }
}
