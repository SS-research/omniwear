import 'dart:developer';
import 'package:omniwear/api/socket_client.dart';
import 'data_transport.dart';

class WebSocketTransport implements DataTransport {
  final _socketClient = SocketClient();

  @override
  Future<void> connect() async {
    _socketClient.connect();
    log("WebSocket connected");
  }

  @override
  Future<void> disconnect() async {
    _socketClient.disconnect();
    log("WebSocket disconnected");
  }

  @override
  Future<void> sendData(String topic, Map<String, dynamic> data) async {
    _socketClient.emit(topic, data);
    log("Data sent via WebSocket: $topic");
  }
}
