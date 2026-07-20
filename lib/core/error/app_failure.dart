enum FailureKind {
  validation,
  authentication,
  session,
  accountRestriction,
  businessRule,
  network,
  timeout,
  rateLimited,
  serverUnavailable,
  server,
  storage,
  cancelled,
  unknown,
}

final class ValidationIssue {
  const ValidationIssue({required this.field, this.code});

  final String field;
  final String? code;

  @override
  String toString() => 'ValidationIssue(field: $field, code: $code)';
}

class AppFailure implements Exception {
  const AppFailure({
    required this.kind,
    required this.messageKey,
    this.code,
    this.traceId,
    this.httpStatus,
    this.validationIssues = const [],
  });

  factory AppFailure.fromBackend({
    required String? code,
    String? traceId,
    int? httpStatus,
    List<ValidationIssue> validationIssues = const [],
  }) {
    final mapping = <String, (FailureKind, String)>{
      'PIN_INVALID': (FailureKind.authentication, 'invalidCredentials'),
      'UNAUTHORIZED': (FailureKind.authentication, 'invalidCredentials'),
      'PIN_LOCKED': (FailureKind.accountRestriction, 'accountLocked'),
      'ACCOUNT_TEMPORARILY_LOCKED': (
        FailureKind.accountRestriction,
        'accountLocked',
      ),
      'REFRESH_TOKEN_REUSED': (FailureKind.session, 'sessionEnded'),
      'REFRESH_TOKEN_EXPIRED': (FailureKind.session, 'sessionExpired'),
      'SESSION_REVOKED': (FailureKind.session, 'sessionEnded'),
      'SESSION_EXPIRED': (FailureKind.session, 'sessionExpired'),
      'USER_SUSPENDED': (FailureKind.accountRestriction, 'accountRestricted'),
      'USER_LOCKED': (FailureKind.accountRestriction, 'accountLocked'),
      'USER_CLOSED': (FailureKind.accountRestriction, 'accountClosed'),
      'FORBIDDEN': (FailureKind.accountRestriction, 'accountRestricted'),
      'VALIDATION_ERROR': (FailureKind.validation, 'validationError'),
      'INVALID_REQUEST': (FailureKind.validation, 'validationError'),
      'RATE_LIMIT_EXCEEDED': (FailureKind.rateLimited, 'serverUnavailable'),
    };
    final value = mapping[code];
    final fallback = httpStatus != null && httpStatus >= 500
        ? (FailureKind.serverUnavailable, 'serverUnavailable')
        : switch (httpStatus) {
            400 => (FailureKind.validation, 'validationError'),
            401 => (FailureKind.authentication, 'invalidCredentials'),
            429 => (FailureKind.rateLimited, 'serverUnavailable'),
            _ => (FailureKind.unknown, 'genericError'),
          };
    return AppFailure(
      kind: value?.$1 ?? fallback.$1,
      messageKey: value?.$2 ?? fallback.$2,
      code: code,
      traceId: traceId,
      httpStatus: httpStatus,
      validationIssues: validationIssues,
    );
  }

  final FailureKind kind;
  final String messageKey;
  final String? code;
  final String? traceId;
  final int? httpStatus;
  final List<ValidationIssue> validationIssues;

  @Deprecated('Use traceId; the backend contract uses X-Trace-Id.')
  String? get requestId => traceId;

  @override
  String toString() =>
      'AppFailure(kind: $kind, status: $httpStatus, traceId: $traceId)';
}
