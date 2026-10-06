import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../../../../core/service/web_socket/websocket_service.dart';

class SensorProvider extends ChangeNotifier {
  SensorProvider({WebSocketService? webSocketService})
    : _webSocketService = webSocketService ?? WebSocketService();

  final WebSocketService _webSocketService;

  StreamSubscription<Map<String, dynamic>>? _subscription;

  Stream<Uint8List> get videoStream => _webSocketService.videoStream;

  String status = 'offline';
  double? temperature;
  double? turbidityRaw;
  double? turbidityVoltage;
  Future<void> refreshConnection() async {
    _webSocketService.disconnect();

    await Future<void>.delayed(const Duration(milliseconds: 300));

    _webSocketService.connect();
  }

  void connect() {
    _webSocketService.connect();

    _subscription = _webSocketService.messages.listen((message) {
      final type = message['type']?.toString();
      log('WebSocket message received: $message', name: 'SensorProvider');
      if (type == 'status') {
        status = message['status']?.toString() ?? 'unknown';
      }

      if (type == 'sensor' || type == 'sensor_data') {
        final rawData = message['data'];
        final data = rawData is Map
            ? Map<String, dynamic>.from(rawData)
            : message;
        log(
          'WebSocket sensor data: ${data['temperature'].toString()}',
          name: 'SensorProvider',
        );
        temperature = _parseDouble(data['temperature']) ?? temperature;
        turbidityRaw =
            _parseDouble(data['turbidity_raw'] ?? data['turbidityRaw']) ??
            turbidityRaw;
        turbidityVoltage =
            _parseDouble(
              data['turbidity_voltage'] ?? data['turbidityVoltage'],
            ) ??
            turbidityVoltage;
      }

      notifyListeners();
    });
  }

  double? _parseDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value.trim());
    }
    return null;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _webSocketService.dispose();
    super.dispose();
  }
}
