import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:aqua_nexis/feature/device_setup/data/models/wifi_credentials.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../app/app_colors.dart';
import '../widgets/aqua_nexis_wifi_connection.dart';

class DeviceSetupScreen extends StatefulWidget {
  const DeviceSetupScreen({super.key});
  static const routeName = '/device-setup';

  @override
  State<DeviceSetupScreen> createState() => _DeviceSetupScreenState();
}

class _DeviceSetupScreenState extends State<DeviceSetupScreen> {
  final List<ScanResult> _scanResults = [];
  StreamSubscription<List<ScanResult>>? _scanResultsSubscription;
  bool _isScanning = false;
  DateTime? _lastScanStartedAt;
  BluetoothCharacteristic? provisionCharacteristic;
  static const String serviceUUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";

  static const String provisionUUID = "beb54850-36e1-4688-b7f5-ea07361b26b0";
  static const Duration _scanCooldown = Duration(seconds: 8);
  String _statusMessage =
      'Tap Scan devices to discover nearby BLE peripherals.';

  @override
  void initState() {
    super.initState();
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      if (!mounted) {
        return;
      }

      final orderedResults = [...results]
        ..sort((left, right) => right.rssi.compareTo(left.rssi));

      for (ScanResult result in orderedResults) {
        log("========================");
        log("Name: ${result.device.platformName}");
        log("Adv Name: ${result.advertisementData.advName}");
        log("ID: ${result.device.remoteId}");
        log("RSSI: ${result.rssi}");
        log("Services: ${result.advertisementData.serviceUuids}");
      }

      setState(() {
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
      });
    });
  }

  @override
  void dispose() {
    _scanResultsSubscription?.cancel();
    if (_isScanning) {
      FlutterBluePlus.stopScan();
    }
    super.dispose();
  }

  Future<void> connectToDevice(
    BluetoothDevice device,
    WifiCredentials credentials,
  ) async {
    try {
      await device.connect(
        license: License.free,
        timeout: const Duration(seconds: 10),
      );

      log("Connected");

      await discoverServices(device);

      await sendProvision(credentials.ssid, credentials.password);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> discoverServices(BluetoothDevice device) async {
    try {
      List<BluetoothService> services = await device.discoverServices();

      log("🔍 Found ${services.length} services");

      for (var service in services) {
        log("📋 Service: ${service.uuid}");

        if (service.uuid.toString().toLowerCase() == serviceUUID) {
          log("✅ Found WiFi Service!");

          for (var c in service.characteristics) {
            log("  └─ Characteristic: ${c.uuid}");
            log("     Properties: ${c.properties}");

            if (c.uuid.toString().toLowerCase() == provisionUUID) {
              provisionCharacteristic = c;
              log("✅ Found Provision Characteristic!");
            }
          }
        }
      }

      if (provisionCharacteristic == null) {
        log("❌ Provision characteristic NOT found");
      }
    } catch (e) {
      log("❌ Error discovering services: $e");
    }
  }

  Future<void> sendProvision(String ssid, String password) async {
    if (provisionCharacteristic == null) {
      log("❌ Provision Characteristic not found");
      return;
    }

    try {
      // Debug: Check characteristic properties
      log("🔍 Characteristic UUID: ${provisionCharacteristic!.uuid}");
      log("🔍 Properties: ${provisionCharacteristic!.properties}");
      log("🔍 Can Write: ${provisionCharacteristic!.properties.write}");

      final payload = {
        "ssid": ssid,
        "password": password,
        "deviceId": "AQX001",
        "server": "https://your-django-server.com",
      };

      final jsonString = jsonEncode(payload);
      log("📤 Sending: $jsonString");

      // Important: Use withoutResponse for faster writing
      await provisionCharacteristic!.write(
        utf8.encode(jsonString),
        withoutResponse: true, // Add this!
      );

      log("✅ Provision Sent Successfully");
    } catch (e) {
      log("❌ Error sending provision: $e");
    }
  }

  Future<void> _startScan() async {
    if (_isScanning) {
      return;
    }

    final lastScanStartedAt = _lastScanStartedAt;
    if (lastScanStartedAt != null) {
      final elapsed = DateTime.now().difference(lastScanStartedAt);
      if (elapsed < _scanCooldown) {
        if (mounted) {
          setState(() {
            _statusMessage =
                'Please wait a few seconds before starting another BLE scan.';
          });
        }
        return;
      }
    }

    if (kIsWeb) {
      setState(() {
        _statusMessage = 'BLE scanning is not supported on web in this app.';
      });
      return;
    }

    final permissionsGranted = await _requestBlePermissions();
    if (!permissionsGranted || !mounted) {
      return;
    }

    final adapterState = await FlutterBluePlus.adapterState.first;
    if (!mounted) {
      return;
    }

    if (adapterState != BluetoothAdapterState.on) {
      setState(() {
        _statusMessage = 'Bluetooth is turned off. Please enable it first.';
      });
      return;
    }

    setState(() {
      _isScanning = true;
      _lastScanStartedAt = DateTime.now();
      _statusMessage = 'Scanning for nearby BLE devices...';
      _scanResults.clear();
    });

    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 6));
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _statusMessage = 'Unable to start BLE scan: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
          if (_scanResults.isEmpty && _statusMessage.startsWith('Scanning')) {
            _statusMessage = 'No nearby BLE devices found.';
          }
        });
      }
    }
  }

  Future<bool> _requestBlePermissions() async {
    final permissionStatuses = await <Permission>[
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    final denied = permissionStatuses.values.any(
      (status) =>
          status.isDenied || status.isPermanentlyDenied || status.isRestricted,
    );

    if (denied) {
      if (mounted) {
        setState(() {
          _statusMessage =
              'Bluetooth and location permissions are required to scan.';
        });
      }
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C3035),
        title: Text(
          'Nearby BLE Devices',
          style: textTheme.titleMedium?.copyWith(
            fontSize: 30,
            color: AppColors.textColorDarkSecondary,
          ),
        ),
        centerTitle: true,
        leadingWidth: 80,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: AppColors.textColorDarkSecondary,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _startScan,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Use BLE to discover nearby devices and identify the AquaNexis unit before moving to setup.',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textColorDarkSecondary,
              ),
            ),
            const SizedBox(height: 16),
            _StatusCard(
              message: _statusMessage,
              isScanning: _isScanning,
              onRefresh: _startScan,
            ),
            const SizedBox(height: 16),
            if (_scanResults.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Center(
                  child: Text(
                    _isScanning
                        ? 'Looking for devices nearby...'
                        : 'Pull to refresh or tap Scan devices.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textColorDarkSecondary,
                    ),
                  ),
                ),
              )
            else
              ..._scanResults.map((result) {
                final deviceName = result.advertisementData.advName.isNotEmpty
                    ? result.advertisementData.advName
                    : 'Unknown device';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.bluetooth_searching),
                      title: Text(deviceName),
                      subtitle: Text(
                        'ID: ${result.device.remoteId}\nRSSI: ${result.rssi}',
                      ),
                      isThreeLine: true,

                      onTap: () => _onTap(result.device),
                    ),
                  ),
                );
              }),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _isScanning ? null : _startScan,
              icon: Icon(_isScanning ? Icons.sync : Icons.search),
              label: Text(_isScanning ? 'Scanning...' : 'Scan devices'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onTap(BluetoothDevice device) async {
    final credentials = await showDialog<WifiCredentials>(
      
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: const AquaNexisWifiConnection(),
        );
      },
    );

    if (!mounted || credentials == null) {
      return;
    }

    await connectToDevice(device, credentials);
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.message,
    required this.isScanning,
    required this.onRefresh,
  });

  final String message;
  final bool isScanning;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: isScanning
                  ? const CircularProgressIndicator(strokeWidth: 2)
                  : const Icon(Icons.info_outline),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: textTheme.bodyMedium)),
            TextButton(
              onPressed: isScanning ? null : onRefresh,
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
