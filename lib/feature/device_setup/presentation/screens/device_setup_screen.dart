import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_colors.dart';
import '../../data/models/wifi_credentials.dart';
import '../providers/device_setup_provider.dart';
import '../widgets/aqua_nexis_wifi_connection.dart';
import '../widgets/device_scan_result_tile.dart';

class DeviceSetupScreen extends StatelessWidget {
  const DeviceSetupScreen({super.key});

  static const routeName = '/device-setup';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DeviceSetupProvider(),
      child: const _DeviceSetupView(),
    );
  }
}

class _DeviceSetupView extends StatelessWidget {
  const _DeviceSetupView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DeviceSetupProvider>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C3035),
        title: Text(
          'Device Setup',
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: provider.startScan,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                message: provider.statusMessage,
                isScanning: provider.isScanning,
                onRefresh: provider.startScan,
              ),
              const SizedBox(height: 16),
              if (provider.scanResults.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Center(
                    child: Text(
                      provider.isScanning
                          ? 'Looking for devices nearby...'
                          : 'Pull to refresh or tap Scan devices.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textColorDarkSecondary,
                      ),
                    ),
                  ),
                )
              else
                ...provider.scanResults.map(
                  (result) => DeviceScanResultTile(
                    result: result,
                    onTap: () => _showWifiDialog(context, result.device),
                  ),
                ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: provider.isScanning ? null : provider.startScan,
                icon: Icon(provider.isScanning ? Icons.sync : Icons.search),
                label: Text(
                  provider.isScanning ? 'Scanning...' : 'Scan devices',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showWifiDialog(
    BuildContext context,
    BluetoothDevice device,
  ) async {
    final credentials = await showDialog<WifiCredentials>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Dialog(
        insetPadding: EdgeInsets.all(16),
        child: AquaNexisWifiConnection(),
      ),
    );
    if (credentials == null || !context.mounted) return;
    await context.read<DeviceSetupProvider>().provision(device, credentials);
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
            Expanded(child: Text(message)),
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
