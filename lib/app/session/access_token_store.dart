abstract interface class AccessTokenSource {
  String? get accessToken;
}

final class AccessTokenStore implements AccessTokenSource {
  String? _accessToken;

  @override
  String? get accessToken => _accessToken;

  void set(String token) {
    if (token.isEmpty) {
      throw ArgumentError.value(token, 'token', 'Must not be empty');
    }
    _accessToken = token;
  }

  void clear() => _accessToken = null;
}
