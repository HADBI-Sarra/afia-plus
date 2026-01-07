import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  // For real phone on same network, use your computer's IP address
  static const String baseUrl =
      'http://192.168.100.7:3000'; // Your PC IP address
  // static const String baseUrl = 'http://10.0.2.2:3000'; // Android emulator
  // static const String baseUrl = 'http://localhost:3000'; // Web
  static const Duration timeout = Duration(seconds: 30);

  static Future<http.Response> get(String endpoint, {String? token}) {
    print('API GET: $baseUrl$endpoint');
    return http
        .get(Uri.parse('$baseUrl$endpoint'), headers: _headers(token))
        .timeout(
          timeout,
          onTimeout: () {
            print('API timeout on GET: $endpoint');
            throw Exception('Request timeout');
          },
        );
  }

  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) {
    print('API POST: $baseUrl$endpoint with body: $body');
    return http
        .post(
          Uri.parse('$baseUrl$endpoint'),
          headers: _headers(token),
          body: jsonEncode(body),
        )
        .timeout(
          timeout,
          onTimeout: () {
            print('API timeout on POST: $endpoint');
            throw Exception('Request timeout');
          },
        );
  }

  static Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) {
    print('API PUT: $baseUrl$endpoint');
    return http
        .put(
          Uri.parse('$baseUrl$endpoint'),
          headers: _headers(token),
          body: jsonEncode(body),
        )
        .timeout(
          timeout,
          onTimeout: () {
            print('API timeout on PUT: $endpoint');
            throw Exception('Request timeout');
          },
        );
  }

  static Future<http.Response> delete(String endpoint, {String? token}) {
    print('API DELETE: $baseUrl$endpoint');
    return http
        .delete(Uri.parse('$baseUrl$endpoint'), headers: _headers(token))
        .timeout(
          timeout,
          onTimeout: () {
            print('API timeout on DELETE: $endpoint');
            throw Exception('Request timeout');
          },
        );
  }

  static Map<String, String> _headers(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
