import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketClient {
  IO.Socket? _socket;
  static SocketClient? _instance;

  SocketClient._internal() {
    _socket = IO.io('http://(your IP Address)', <String, dynamic>{  
      'transports': ['websocket'],
      'autoConnect': false,
    });
    _socket!
      ..onConnect((_) => debugPrint('Socket connected: ${_socket!.id}'))
      ..onConnectError((error) => debugPrint('Socket connect error: $error'))
      ..onError((error) => debugPrint('Socket error: $error'))
      ..onDisconnect((_) => debugPrint('Socket disconnected'));
    _socket!.connect();
  }

  static SocketClient get instance {
    _instance ??= SocketClient._internal();
    return _instance!;
  }

  IO.Socket get socket => _socket!;
}
