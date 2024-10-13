import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:omniwear/config/config_manager.dart';

class ApiClient {
  final Dio _client;

  ApiClient()
      : _client = Dio(
          BaseOptions(
            baseUrl: ConfigManager.instance.config.baseUrl,
            sendTimeout: const Duration(milliseconds: 60000),
            receiveTimeout: const Duration(milliseconds: 60000),
            connectTimeout: const Duration(milliseconds: 60000),
            followRedirects: false,
            receiveDataWhenStatusError: true,
            headers: {
              'accept': '*/*',
              'Content-Type': 'application/json',
            },
          ),
        );

  // GET request method
  Future<dynamic> get(
    String url, {
    Map<String, String>? queryParams = const {},
    Map<String, String>? headers = const {},
  }) async {
    log('GET $url');
    return await _request(
      () => _client.get(url, queryParameters: queryParams),
      headers: headers,
    );
  }

  // POST request method
  Future<dynamic> post(
    String url,
    dynamic payLoad, {
    Map<String, String>? headers = const {},
  }) async {
    log('POST $url');
    return await _request(
      () => _client.post(url, data: payLoad),
      headers: headers,
    );
  }

  // Unified request handler for GET and POST
  Future<dynamic> _request(
    Future<Response> Function() request, {
    Map<String, String>? headers,
  }) async {
    try {
      // Apply custom headers
      _client.options.headers.addAll(headers ?? {});

      // Send the request
      final response = await request();

      return response.data;
    } on DioException catch (e) {
      log('Request failed: ${e.message}');
      log('DioException: ${e.response?.data}');
      return null;
    } catch (e) {
      log('Unexpected error: $e');
      return null;
    }
  }
}
