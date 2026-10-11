import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/storage/auth_storage.dart';
import '../models/wifi_credentials.dart';

class BleProvisioningService {
  static const String serviceUuid = '4fafc201-1fb5-459e-8fcc-c5c9c331914b';
  static const String provisionUuid = 'beb54850-36e1-4688-b7f5-ea07361b26b0';

  BluetoothCharacteristic? _provisionCharacteristic;

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

  }

  Future<void> _discoverServices(BluetoothDevice device) async {
    _provisionCharacteristic = null;

    final services = await device.discoverServices();
    for (final service in services) {
      if (service.uuid.toString().toLowerCase() != serviceUuid) continue;

      for (final characteristic in service.characteristics) {
        final uuid = characteristic.uuid.toString().toLowerCase();
        if (uuid == provisionUuid) {
          _provisionCharacteristic = characteristic;
        }
      }
    }
  }

  Future<void> dispose() async {}
}
