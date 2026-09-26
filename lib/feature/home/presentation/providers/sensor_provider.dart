import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/service/web_socket/websocket_service.dart';



class SensorProvider extends ChangeNotifier {
  final WebSocketService _webSocketService = WebSocketService();

  StreamSubscription<Map<String, dynamic>>? _subscription;

  String status = 'offline';
  double? temperature;
  double? turbidityRaw;
  double? turbidityVoltage;
  Future<void> refreshConnection() async {
  _webSocketService.disconnect();

  await Future<void>.delayed(
    const Duration(milliseconds: 300),
  );

  _webSocketService.connect();
}
  void connect() {
    _webSocketService.connect();

    _subscription = _webSocketService.messages.listen((message) {
      final type = message['type'];

      if (type == 'status') {
        status = message['status']?.toString() ?? 'unknown';
      }

      if (type == 'sensor') {
        final data = Map<String, dynamic>.from(message['data'] as Map);

        temperature = (data['temperature'] as num?)?.toDouble();
        turbidityRaw = (data['turbidity_raw'] as num?)?.toDouble();
        turbidityVoltage = (data['turbidity_voltage'] as num?)?.toDouble();
      }

      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _webSocketService.dispose();
    super.dispose();
  }
}