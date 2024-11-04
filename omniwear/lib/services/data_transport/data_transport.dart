
abstract class DataTransport {
  Future<void> connect();
  Future<void> disconnect();
  Future<void> sendData(String topic, Map<String, dynamic> data);
}
