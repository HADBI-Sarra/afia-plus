import 'package:shared_preferences/shared_preferences.dart';

class TokenProvider {
  static const String _tokenKey = 'supabase_access_token';
  String? _accessToken;
  SharedPreferences? _prefs;

  String? get accessToken => _accessToken;

  /// Initialize the TokenProvider and load token from storage
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    _accessToken = _prefs?.getString(_tokenKey);
  }

  /// Set the access token and persist it to storage
  Future<void> setToken(String token) async {
    _accessToken = token;
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setString(_tokenKey, token);
  }

  /// Clear the access token from memory and storage
  Future<void> clear() async {
    _accessToken = null;
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.remove(_tokenKey);
  }

  bool get isAuthenticated => _accessToken != null;
}
