import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/storage/auth_storage.dart';
import '../models/wifi_credentials.dart';

class BleProvisioningService {
  static const String serviceUuid = '4fafc201-1fb5-459e-8fcc-c5c9c331914b';
  static const String provisionUuid = 'beb54850-36e1-4688-b7f5-ea07361b26b0';
  static const String statusUuid = 'beb54841-36e1-4688-b7f5-ea07361b26a4';

  BluetoothCharacteristic? _provisionCharacteristic;
  BluetoothCharacteristic? _statusCharacteristic;
  StreamSubscription<List<int>>? _statusSubscription;
  Completer<String?>? _statusResponseCompleter;

  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  Future<bool> requestPermissions() async {
    final statuses = await <Permission>[
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    return !statuses.values.any(
      (status) =>
          status.isDenied || status.isPermanentlyDenied || status.isRestricted,
    );
  }

  Future<void> scan() {
    return FlutterBluePlus.startScan(timeout: const Duration(seconds: 6));
  }

  Future<void> stopScan() => FlutterBluePlus.stopScan();

  Future<bool> isBluetoothEnabled() async {
    final state = await FlutterBluePlus.adapterState.first;
    return state == BluetoothAdapterState.on;
  }

  Future<void> provision(
    BluetoothDevice device,
    WifiCredentials credentials,
  ) async {
    await device.connect(
      license: License.nonprofit,
      timeout: const Duration(seconds: 10),
    );
    await device.connectionState.first;
    await _discoverServices(device);

    final characteristic = _provisionCharacteristic;
    if (characteristic == null) {
      throw StateError('Provision characteristic was not found.');
    }

    final payload = {
      'ssid': credentials.ssid,
      'password': credentials.password,
      'deviceId':
          credentials.deviceId ?? AuthStorage.userData?.device?.deviceId ?? '',
      'server': credentials.server ?? 'aquanexis-backend.onrender.com',
      'deviceWebSocketUrl': credentials.deviceWebSocketUrl ?? '',
    };

    await characteristic.write(
      utf8.encode(jsonEncode(payload)),
      withoutResponse: true,
    );

    final response = await _waitForStatusResponse(
      timeout: const Duration(seconds: 20),
    );
    if (response == null) {
      throw TimeoutException('The device did not confirm the Wi-Fi setup.');
    }
    if (!response.toLowerCase().contains('success')) {
      throw StateError('The device reported a Wi-Fi connection failure.');
    }
  }

  Future<void> _discoverServices(BluetoothDevice device) async {
    _provisionCharacteristic = null;
    _statusCharacteristic = null;

    final services = await device.discoverServices();
    for (final service in services) {
      if (service.uuid.toString().toLowerCase() != serviceUuid) continue;

      for (final characteristic in service.characteristics) {
        final uuid = characteristic.uuid.toString().toLowerCase();
        if (uuid == provisionUuid) {
          _provisionCharacteristic = characteristic;
        } else if (uuid == statusUuid) {
          _statusCharacteristic = characteristic;
          await characteristic.setNotifyValue(true);
          await _statusSubscription?.cancel();
          _statusSubscription = characteristic.onValueReceived.listen((value) {
            final response = utf8.decode(value).trim();
            log('Device status response: $response');
            final completer = _statusResponseCompleter;
            if (completer != null && !completer.isCompleted) {
              completer.complete(response);
            }
          });
        }
      }
    }
  }

  Future<String?> _waitForStatusResponse({required Duration timeout}) async {
    if (_statusCharacteristic == null) return null;

    _statusResponseCompleter = Completer<String?>();
    try {
      return await _statusResponseCompleter!.future.timeout(
        timeout,
        onTimeout: () => null,
      );
    } finally {
      _statusResponseCompleter = null;
    }
  }

  Future<void> dispose() async {
    await _statusSubscription?.cancel();
    _statusResponseCompleter = null;
  }
}
