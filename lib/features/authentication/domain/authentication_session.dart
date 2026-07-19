final class AuthenticationSession {
  const AuthenticationSession({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.sessionId,
  });

  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final String sessionId;

  @override
  String toString() =>
      'AuthenticationSession(tokenType: $tokenType, sessionId: [REDACTED])';
}
