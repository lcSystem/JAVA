import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WebSocketClient {
  WebSocketChannel? _channel;
  final String url;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  WebSocketClient({required this.url});

  Future<void> connect() async {
    final token = await storage.read(key: 'jwtToken');
    if (token == null) return;

    final wsUrl = '$url?token=$token';
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
  }

  Stream<dynamic>? get stream => _channel?.stream;

  void send(dynamic message) {
    _channel?.sink.add(message);
  }

  void disconnect() {
    _channel?.sink.close(status.goingAway);
  }
}
