import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../../home/presentation/providers/sensor_provider.dart';
import '../../data/models/wifi_credentials.dart';
import '../../data/services/ble_provisioning_service.dart';

class DeviceSetupProvider extends ChangeNotifier {
  DeviceSetupProvider({
    BleProvisioningService? service,
    required SensorProvider sensorProvider,
  }) : _service = service ?? BleProvisioningService(),
       _sensorProvider = sensorProvider {
    _scanSubscription = _service.scanResults.listen(_onScanResults);
  }

  final BleProvisioningService _service;
  final SensorProvider _sensorProvider;
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  final List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  bool _isProvisioning = false;
  DateTime? _lastScanStartedAt;
  String _statusMessage =
      'Tap Scan devices to discover nearby BLE peripherals.';

  List<ScanResult> get scanResults => List.unmodifiable(_scanResults);
  bool get isScanning => _isScanning;
  bool get isProvisioning => _isProvisioning;
  String get statusMessage => _statusMessage;

  Future<void> startScan() async {
    if (_isScanning) return;

    final lastScan = _lastScanStartedAt;
    if (lastScan != null &&
        DateTime.now().difference(lastScan) < const Duration(seconds: 8)) {
      _setStatus('Please wait a few seconds before starting another BLE scan.');
      return;
    }
    if (kIsWeb) {
      _setStatus('BLE scanning is not supported on web in this app.');
      return;
    }
    if (!await _service.requestPermissions()) {
      _setStatus('Bluetooth and location permissions are required to scan.');
      return;
    }
    if (!await _service.isBluetoothEnabled()) {
      _setStatus('Bluetooth is turned off. Please enable it first.');
      return;
    }

    _isScanning = true;
    _lastScanStartedAt = DateTime.now();
    _scanResults.clear();
    _setStatus('Scanning for nearby BLE devices...');
    try {
      await _service.scan();
    } catch (error) {
      _setStatus('Unable to start BLE scan: $error');
    } finally {
      _isScanning = false;
      if (_scanResults.isEmpty && _statusMessage.startsWith('Scanning')) {
        _setStatus('No nearby BLE devices found.');
      } else {
        notifyListeners();
      }
    }
  }

  Future<void> provision(
    BluetoothDevice device,
    WifiCredentials credentials,
  ) async {
    _isProvisioning = true;
    _setStatus('Sending Wi-Fi credentials to the device...');
    try {
      await _service.provision(device, credentials);

      _setStatus('Waiting for the device to connect to Wi-Fi...');
      await Future<void>.delayed(const Duration(seconds: 20));

      if (_sensorProvider.status.toLowerCase() == 'online') {
        _setStatus('🟡 Device connected to the Wi-Fi successfully.');
      } else {
        _setStatus('🔴 Wi-Fi connection failure.');
      }
    } catch (error) {
      log('Device provisioning failed: $error');
      _setStatus('Device setup failed: $error');
    } finally {
      _isProvisioning = false;
      notifyListeners();
    }
  }

  void _onScanResults(List<ScanResult> results) {
    final orderedResults = [...results]
      ..sort((left, right) => right.rssi.compareTo(left.rssi));
    _scanResults
      ..clear()
      ..addAll(orderedResults);
    if (orderedResults.isEmpty) {
      _statusMessage = _isScanning
          ? 'Scanning for nearby BLE devices...'
          : 'No nearby BLE devices found yet.';
    } else {
      _statusMessage = 'Found ${orderedResults.length} nearby device(s).';
    }
    notifyListeners();
  }

  void _setStatus(String message) {
    _statusMessage = message;
    notifyListeners();
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _service.stopScan();
    _service.dispose();
    super.dispose();
  }
}
