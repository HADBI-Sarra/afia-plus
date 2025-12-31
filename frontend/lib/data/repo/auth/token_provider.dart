class TokenProvider {
  String? _accessToken;

  String? get accessToken => _accessToken;

  void setToken(String token) {
    _accessToken = token;
  }

  void clear() {
    _accessToken = null;
  }

  bool get isAuthenticated => _accessToken != null;
}
