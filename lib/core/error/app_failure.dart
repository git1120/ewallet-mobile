enum FailureKind {
  validation,
  authentication,
  session,
  accountRestriction,
  businessRule,
  network,
  server,
  storage,
  unknown,
}

final class AppFailure implements Exception {
  const AppFailure({
    required this.kind,
    required this.messageKey,
    this.requestId,
  });

  factory AppFailure.fromBackend({required String? code, String? requestId}) {
    final mapping = <String, (FailureKind, String)>{
      'PIN_INVALID': (FailureKind.authentication, 'invalidCredentials'),
      'PIN_LOCKED': (FailureKind.accountRestriction, 'accountLocked'),
      'REFRESH_TOKEN_REUSED': (FailureKind.session, 'sessionEnded'),
      'REFRESH_TOKEN_EXPIRED': (FailureKind.session, 'sessionExpired'),
      'SESSION_REVOKED': (FailureKind.session, 'sessionEnded'),
      'SESSION_EXPIRED': (FailureKind.session, 'sessionExpired'),
      'USER_SUSPENDED': (FailureKind.accountRestriction, 'accountRestricted'),
      'USER_LOCKED': (FailureKind.accountRestriction, 'accountLocked'),
      'USER_CLOSED': (FailureKind.accountRestriction, 'accountClosed'),
    };
    final value = mapping[code];
    return AppFailure(
      kind: value?.$1 ?? FailureKind.server,
      messageKey: value?.$2 ?? 'genericError',
      requestId: requestId,
    );
  }

  final FailureKind kind;
  final String messageKey;
  final String? requestId;

  @override
  String toString() => 'AppFailure($kind, requestId: $requestId)';
}
