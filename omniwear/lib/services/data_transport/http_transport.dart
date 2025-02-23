import 'dart:async';
import 'dart:developer';
import 'package:omniwear/api/api_client.dart';
import 'data_transport.dart';

class HttpTransport implements DataTransport {
  final ApiClient _apiClient = ApiClient();

  @override
  Future<void> connect() async {
    log("HTTP transport initialized");
  }

  @override
  Future<void> disconnect() async {
    log("HTTP transport stopped");
  }

  @override
  Future<void> sendData(String topic, Map<String, dynamic> data) async {
    try {
      await _apiClient.post('/$topic', data);
      log("Data sent via HTTP for $topic: $data");
    } catch (e) {
      log("Failed to send data via HTTP: $e");
    }
  }
}
