import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:local_shopee/config/environment_config.dart';

/// API service for handling HTTP requests with environment configuration
class ApiService {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final EnvironmentConfig _config = EnvironmentConfig.instance;

  // Base headers for all requests
  Map<String, String> get _baseHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': '${_config.appName}/${_config.appVersion}',
  };

  // Get request with environment configuration
  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('${_config.apiBaseUrl}$endpoint');
    final combinedHeaders = {..._baseHeaders, ...?headers};

    if (_config.enableDebugMode) {
      print('GET Request: $uri');
      print('Headers: $combinedHeaders');
    }

    try {
      final response = await http
          .get(uri, headers: combinedHeaders)
          .timeout(Duration(milliseconds: _config.apiTimeout));

      if (_config.enableDebugMode) {
        print('Response Status: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }

      return response;
    } catch (e) {
      if (_config.enableDebugMode) {
        print('API Error: $e');
      }
      rethrow;
    }
  }

  // Post request with environment configuration
  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('${_config.apiBaseUrl}$endpoint');
    final combinedHeaders = {..._baseHeaders, ...?headers};

    if (_config.enableDebugMode) {
      print('POST Request: $uri');
      print('Headers: $combinedHeaders');
      print('Body: ${jsonEncode(body)}');
    }

    try {
      final response = await http
          .post(
            uri,
            headers: combinedHeaders,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(Duration(milliseconds: _config.apiTimeout));

      if (_config.enableDebugMode) {
        print('Response Status: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }

      return response;
    } catch (e) {
      if (_config.enableDebugMode) {
        print('API Error: $e');
      }
      rethrow;
    }
  }

  // Example method using the service
  Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
    try {
      final response = await get('/users/$userId');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw HttpException(
          'Failed to fetch user profile: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (_config.enableDebugMode) {
        print('Error fetching user profile: $e');
      }
      return null;
    }
  }

  // Example method for creating user data
  Future<bool> createUserProfile(Map<String, dynamic> userData) async {
    try {
      final response = await post('/users', body: userData);
      return response.statusCode == 201;
    } catch (e) {
      if (_config.enableDebugMode) {
        print('Error creating user profile: $e');
      }
      return false;
    }
  }
}
