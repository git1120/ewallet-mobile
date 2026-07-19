import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:iba_ewallet/app/session/authentication_session_manager.dart';
import 'package:iba_ewallet/core/api/api_client.dart';
import 'package:iba_ewallet/core/error/app_failure.dart';
import 'package:iba_ewallet/features/authentication/domain/authentication_repository.dart';
import 'package:iba_ewallet/features/authentication/domain/authentication_state.dart';

final class AuthenticationController extends ChangeNotifier {
  AuthenticationController({
    required AuthenticationRepository repository,
    required AuthenticationSessionManager sessionManager,
    required ApiClient apiClient,
  }) : _repository = repository,
       _sessionManager = sessionManager {
    apiClient.configureRefresh(_refreshForProtectedRequest);
  }

  final AuthenticationRepository _repository;
  final AuthenticationSessionManager _sessionManager;

  AuthenticationState _state = const AuthenticationState.initial();
  AuthenticationState get state => _state;

  int _operationGeneration = 0;
  CancelToken? _loginCancellation;
  CancelToken? _confirmationCancellation;
  bool _disposed = false;

  Future<void> restore() async {
    final operation = ++_operationGeneration;
    _emit(const AuthenticationState.initial());
    try {
      final refreshToken = await _sessionManager.storedRefreshToken();
      if (!_isCurrent(operation)) return;
      if (refreshToken == null) {
        _emit(
          _state.copyWith(
            session: SessionStatus.unauthenticated,
            loginStage: LoginStage.mobileEntry,
          ),
        );
        return;
      }
      _emit(_state.copyWith(session: SessionStatus.establishing));
      final accessToken = await _sessionManager.refresh();
      if (!_isCurrent(operation)) return;
      if (accessToken == null) {
        await _endSession(AuthenticationTerminalReason.invalidRefresh);
        return;
      }
      _emit(_state.copyWith(session: SessionStatus.authenticatedUnconfirmed));
      if (await _confirm(operation)) {
        _emit(
          _state.copyWith(
            session: SessionStatus.authenticated,
            request: AuthenticationRequestStatus.idle,
          ),
        );
      } else if (_isCurrent(operation)) {
        await _endSession(AuthenticationTerminalReason.invalidRefresh);
      }
    } catch (error) {
      if (_isCurrent(operation)) {
        await _handleTerminalFailure(_failureOf(error));
      }
    }
  }

  void continueToPin() {
    if (_state.session != SessionStatus.unauthenticated ||
        _state.isSubmitting) {
      return;
    }
    _emit(
      _state.copyWith(
        loginStage: LoginStage.pinEntry,
        request: AuthenticationRequestStatus.idle,
      ),
    );
  }

  void changeMobile() {
    if (_state.isSubmitting) return;
    _emit(
      _state.copyWith(
        loginStage: LoginStage.mobileEntry,
        request: AuthenticationRequestStatus.idle,
        restriction: AccountRestriction.none,
      ),
    );
  }

  void cancelLoginAttempt() {
    if (!_state.isSubmitting) return;
    ++_operationGeneration;
    _loginCancellation?.cancel();
    _emit(
      _state.copyWith(
        session: SessionStatus.unauthenticated,
        loginStage: LoginStage.pinEntry,
        request: AuthenticationRequestStatus.cancelled,
      ),
    );
  }

  Future<void> login({
    required String mobileNumber,
    required String pin,
  }) async {
    if (_state.isSubmitting ||
        _state.session != SessionStatus.unauthenticated) {
      return;
    }
    final operation = ++_operationGeneration;
    _loginCancellation?.cancel();
    final cancellation = CancelToken();
    _loginCancellation = cancellation;
    _emit(
      _state.copyWith(
        loginStage: LoginStage.submitting,
        request: AuthenticationRequestStatus.inFlight,
        restriction: AccountRestriction.none,
        terminalReason: AuthenticationTerminalReason.none,
      ),
    );
    try {
      final session = await _repository.login(
        mobileNumber: mobileNumber,
        pin: pin,
        cancelToken: cancellation,
      );
      if (!_isCurrent(operation)) return;
      await _sessionManager.establish(session);
      if (!_isCurrent(operation)) return;
      _emit(_state.copyWith(session: SessionStatus.authenticatedUnconfirmed));
      if (!await _confirm(operation)) {
        if (_isCurrent(operation)) {
          await _endSession(AuthenticationTerminalReason.invalidRefresh);
        }
        return;
      }
      if (_isCurrent(operation)) {
        _emit(
          _state.copyWith(
            session: SessionStatus.authenticated,
            loginStage: LoginStage.pinEntry,
            request: AuthenticationRequestStatus.idle,
          ),
        );
      }
    } catch (error) {
      if (_isCurrent(operation)) await _handleLoginFailure(_failureOf(error));
    } finally {
      if (identical(_loginCancellation, cancellation)) {
        _loginCancellation = null;
      }
    }
  }

  Future<void> logout() async {
    if (_state.session != SessionStatus.authenticated) return;
    ++_operationGeneration;
    _loginCancellation?.cancel();
    _confirmationCancellation?.cancel();
    _sessionManager.invalidate();
    _emit(_state.copyWith(session: SessionStatus.loggingOut));
    try {
      await _repository.logout();
    } catch (_) {
      // Local logout is authoritative for this device.
    } finally {
      await _sessionManager.clear();
      _emit(
        const AuthenticationState(
          session: SessionStatus.unauthenticated,
          loginStage: LoginStage.mobileEntry,
          request: AuthenticationRequestStatus.idle,
          restriction: AccountRestriction.none,
          terminalReason: AuthenticationTerminalReason.logout,
        ),
      );
    }
  }

  Future<void> acknowledgeTerminalState() async {
    await _sessionManager.clear();
    _emit(
      const AuthenticationState(
        session: SessionStatus.unauthenticated,
        loginStage: LoginStage.mobileEntry,
        request: AuthenticationRequestStatus.idle,
        restriction: AccountRestriction.none,
        terminalReason: AuthenticationTerminalReason.none,
      ),
    );
  }

  Future<String?> _refreshForProtectedRequest() async {
    if (_state.session != SessionStatus.authenticated &&
        _state.session != SessionStatus.authenticatedUnconfirmed) {
      return null;
    }
    final operation = _operationGeneration;
    _emit(_state.copyWith(session: SessionStatus.refreshing));
    try {
      final token = await _sessionManager.refresh();
      if (!_isCurrent(operation) || token == null) return null;
      _emit(_state.copyWith(session: SessionStatus.authenticated));
      return token;
    } catch (error) {
      if (_isCurrent(operation)) {
        await _handleTerminalFailure(_failureOf(error));
      }
      return null;
    }
  }

  Future<bool> _confirm(int operation) async {
    _confirmationCancellation?.cancel();
    final cancellation = CancelToken();
    _confirmationCancellation = cancellation;
    try {
      return await _sessionManager.confirm() && _isCurrent(operation);
    } finally {
      if (identical(_confirmationCancellation, cancellation)) {
        _confirmationCancellation = null;
      }
    }
  }

  Future<void> _handleLoginFailure(AppFailure failure) async {
    switch (failure.code) {
      case 'PIN_LOCKED':
      case 'ACCOUNT_TEMPORARILY_LOCKED':
        _emit(
          _state.copyWith(
            session: SessionStatus.unauthenticated,
            loginStage: LoginStage.temporarilyLocked,
            request: AuthenticationRequestStatus.idle,
          ),
        );
        return;
      case 'USER_SUSPENDED':
      case 'USER_LOCKED':
      case 'USER_CLOSED':
        await _handleTerminalFailure(failure);
        return;
      default:
        final request = switch (failure.kind) {
          FailureKind.network ||
          FailureKind.timeout => AuthenticationRequestStatus.offline,
          FailureKind.serverUnavailable ||
          FailureKind.server => AuthenticationRequestStatus.serverUnavailable,
          FailureKind.cancelled => AuthenticationRequestStatus.cancelled,
          _ => AuthenticationRequestStatus.idle,
        };
        _emit(
          _state.copyWith(
            session: SessionStatus.unauthenticated,
            loginStage: failure.kind == FailureKind.authentication
                ? LoginStage.invalidCredentials
                : LoginStage.pinEntry,
            request: request,
          ),
        );
    }
  }

  Future<void> _handleTerminalFailure(AppFailure failure) async {
    final restriction = switch (failure.code) {
      'USER_SUSPENDED' => AccountRestriction.suspended,
      'USER_LOCKED' => AccountRestriction.lockedOrBlocked,
      'USER_CLOSED' => AccountRestriction.closed,
      'FORBIDDEN' => AccountRestriction.other,
      _ => AccountRestriction.none,
    };
    final reason = switch (failure.code) {
      'REFRESH_TOKEN_REUSED' => AuthenticationTerminalReason.refreshReused,
      'REFRESH_TOKEN_EXPIRED' ||
      'SESSION_EXPIRED' => AuthenticationTerminalReason.expired,
      'SESSION_REVOKED' => AuthenticationTerminalReason.revoked,
      'USER_SUSPENDED' ||
      'USER_LOCKED' ||
      'USER_CLOSED' ||
      'FORBIDDEN' => AuthenticationTerminalReason.accountRestricted,
      _ => AuthenticationTerminalReason.invalidRefresh,
    };
    await _sessionManager.clear();
    _emit(
      AuthenticationState(
        session: SessionStatus.terminal,
        loginStage: LoginStage.mobileEntry,
        request: AuthenticationRequestStatus.idle,
        restriction: restriction,
        terminalReason: reason,
      ),
    );
  }

  Future<void> _endSession(AuthenticationTerminalReason reason) async {
    await _sessionManager.clear();
    _emit(
      AuthenticationState(
        session: SessionStatus.terminal,
        loginStage: LoginStage.mobileEntry,
        request: AuthenticationRequestStatus.idle,
        restriction: AccountRestriction.none,
        terminalReason: reason,
      ),
    );
  }

  bool _isCurrent(int operation) =>
      !_disposed && operation == _operationGeneration;

  void _emit(AuthenticationState next) {
    if (_disposed) return;
    _state = next;
    notifyListeners();
  }

  AppFailure _failureOf(Object error) {
    if (error is AppFailure) return error;
    if (error is DioException && error.error is AppFailure) {
      return error.error! as AppFailure;
    }
    return const AppFailure(
      kind: FailureKind.unknown,
      messageKey: 'genericError',
    );
  }

  @override
  void dispose() {
    _disposed = true;
    ++_operationGeneration;
    _loginCancellation?.cancel();
    _confirmationCancellation?.cancel();
    super.dispose();
  }
}
