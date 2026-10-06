import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:aqua_nexis/core/storage/auth_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../app/urls.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  bool _isDisposed = false;

  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();

  final StreamController<Uint8List> _videoController =
      StreamController<Uint8List>.broadcast();

  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  Stream<Uint8List> get videoStream => _videoController.stream;

  void connect() {
    if (_isDisposed) {
      throw StateError('WebSocketService has already been disposed.');
    }

    if (_channel != null) {
      return;
    }

    String uri = Urls.webSocketUrl(
      AuthStorage.userData!.device!.deviceId,
      AuthStorage.userData!.token!,
    );

    _channel = WebSocketChannel.connect(Uri.parse(uri));
    log('WebSocket connected to $uri', name: 'WebSocketService');
    _channel!.stream.listen(
      _handleMessage,
      onError: (error) {
        log('WebSocket error: $error');

        if (!_messageController.isClosed) {
          _messageController.addError(error);
        }

        if (!_videoController.isClosed) {
          _videoController.addError(error);
        }
      },
      onDone: () {
        log('WebSocket connection closed');
        _channel = null;
      },
    );
  }

  void _handleMessage(dynamic message) {
    if (message is List<int>) {
      _videoController.add(Uint8List.fromList(message));
      return;
    }

    if (message is String) {
      try {
        final decodedData = jsonDecode(message);

        if (decodedData is Map) {
          final data = Map<String, dynamic>.from(decodedData);
          _messageController.add(data);
        }
      } catch (error) {
        log('Received invalid JSON message: $error');
        _messageController.addError(error);
      }

      return;
    }

    log('Unsupported WebSocket message type: ${message.runtimeType}');
  }

  void send(Map<String, dynamic> data) {
    _channel?.sink.add(jsonEncode(data));
  }

  void sendBytes(Uint8List bytes) {
    _channel?.sink.add(bytes);
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;
    disconnect();
    _messageController.close();
    _videoController.close();
  }
}
