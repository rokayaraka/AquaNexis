import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceScanResultTile extends StatelessWidget {
  const DeviceScanResultTile({
    required this.result,
    required this.onTap,
    super.key,
  });

  final ScanResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = result.advertisementData.advName.isNotEmpty
        ? result.advertisementData.advName
        : 'Unknown device';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.bluetooth_searching),
          title: Text(name),
          subtitle: Text('ID: ${result.device.remoteId}\nRSSI: ${result.rssi}'),
          isThreeLine: true,
          onTap: onTap,
        ),
      ),
    );
  }
}
