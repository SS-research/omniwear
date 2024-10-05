import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:omniwear/config/config_manager.dart';

class SocketClient {
  IO.Socket? _socket;

  // Constructor
  SocketClient();

  void connect() {
    log('connecting to socket ${ConfigManager.instance.config.baseUrl}');
    _socket = IO.io(ConfigManager.instance.config.baseUrl, <String, dynamic>{
      'transports': ['websocket'], // Use WebSocket transport only
      'autoConnect': false, // Do not auto-connect
    });

    _socket!.connect();

    // Listen for incoming messages from the server
    _socket!.on('message', (data) {
      log('Received: $data');
    });

    _socket!.onConnectError((error) {
      log('Socket.IO connection error: $error');
    });

    _socket!.onDisconnect((_) {
      log('Socket.IO connection closed.');
    });
  }

  void disconnect() {
    _socket?.disconnect();
  }

  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }

  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  bool isConnected() {
    return _socket?.connected ?? false;
  }
}
