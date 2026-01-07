import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class ApiClient {
  // For real phone on same network, use your computer's IP address
  static const String baseUrl = 'http://10.28.198.117:3000'; // Your PC IP address
  // static const String baseUrl = 'http://10.0.2.2:3000'; // Android emulator
  // static const String baseUrl = 'http://localhost:3000'; // Web
  static const Duration timeout = Duration(seconds: 30);

  static Future<http.Response> get(
    String endpoint, {
    String? token,
  }) {
    print('API GET: $baseUrl$endpoint');
    return http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers(token),
    ).timeout(timeout, onTimeout: () {
      print('API timeout on GET: $endpoint');
      throw Exception('Request timeout');
    });
  }

  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) {
    print('API POST: $baseUrl$endpoint with body: $body');
    return http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers(token),
      body: jsonEncode(body),
    ).timeout(timeout, onTimeout: () {
      print('API timeout on POST: $endpoint');
      throw Exception('Request timeout');
    });
  }

  static Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) {
    print('API PUT: $baseUrl$endpoint');
    return http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers(token),
      body: jsonEncode(body),
    ).timeout(timeout, onTimeout: () {
      print('API timeout on PUT: $endpoint');
      throw Exception('Request timeout');
    });
  }

  static Future<http.Response> postMultipart(
    String endpoint,
    String filePath, {
    String? token,
    String fieldName = 'file',
  }) async {
    print('API POST MULTIPART: $baseUrl$endpoint');
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File does not exist: $filePath');
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl$endpoint'),
    );

    // Add authorization header if token is provided
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // Add file
    final fileName = path.basename(filePath);
    final fileStream = http.ByteStream(file.openRead());
    final fileLength = await file.length();
    final multipartFile = http.MultipartFile(
      fieldName,
      fileStream,
      fileLength,
      filename: fileName,
    );
    request.files.add(multipartFile);

    final streamedResponse = await request.send().timeout(timeout, onTimeout: () {
      print('API timeout on POST MULTIPART: $endpoint');
      throw Exception('Request timeout');
    });

    return await http.Response.fromStream(streamedResponse);
  }

  static Map<String, String> _headers(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
