enum SessionStatus {
  bootstrapping,
  unauthenticated,
  establishing,
  authenticatedUnconfirmed,
  authenticated,
  refreshing,
  loggingOut,
  terminal,
}

enum LoginStage {
  mobileEntry,
  pinEntry,
  submitting,
  invalidCredentials,
  temporarilyLocked,
}

enum AuthenticationRequestStatus {
  idle,
  inFlight,
  offline,
  serverUnavailable,
  cancelled,
}

enum AccountRestriction { none, suspended, lockedOrBlocked, closed, other }

enum AuthenticationTerminalReason {
  none,
  expired,
  revoked,
  refreshReused,
  invalidRefresh,
  accountRestricted,
  logout,
}

final class AuthenticationState {
  const AuthenticationState({
    required this.session,
    required this.loginStage,
    required this.request,
    required this.restriction,
    required this.terminalReason,
  });

  const AuthenticationState.initial()
    : session = SessionStatus.bootstrapping,
      loginStage = LoginStage.mobileEntry,
      request = AuthenticationRequestStatus.idle,
      restriction = AccountRestriction.none,
      terminalReason = AuthenticationTerminalReason.none;

  final SessionStatus session;
  final LoginStage loginStage;
  final AuthenticationRequestStatus request;
  final AccountRestriction restriction;
  final AuthenticationTerminalReason terminalReason;

  bool get isAuthenticated => session == SessionStatus.authenticated;
  bool get isBootstrapping =>
      session == SessionStatus.bootstrapping ||
      session == SessionStatus.establishing ||
      session == SessionStatus.authenticatedUnconfirmed;
  bool get isSubmitting => loginStage == LoginStage.submitting;

  AuthenticationState copyWith({
    SessionStatus? session,
    LoginStage? loginStage,
    AuthenticationRequestStatus? request,
    AccountRestriction? restriction,
    AuthenticationTerminalReason? terminalReason,
  }) => AuthenticationState(
    session: session ?? this.session,
    loginStage: loginStage ?? this.loginStage,
    request: request ?? this.request,
    restriction: restriction ?? this.restriction,
    terminalReason: terminalReason ?? this.terminalReason,
  );
}
