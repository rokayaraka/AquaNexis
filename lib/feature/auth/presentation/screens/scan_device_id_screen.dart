import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../app/app_colors.dart';

class ScanDeviceIdScreen extends StatefulWidget {
  const ScanDeviceIdScreen({super.key});
  static const String routeName = '/scan_device_id';
  @override
  State<ScanDeviceIdScreen> createState() => _ScanDeviceIdScreenState();
}

class _ScanDeviceIdScreenState extends State<ScanDeviceIdScreen> {
  final MobileScannerController _controller = MobileScannerController(
    facing: CameraFacing.back,
    torchEnabled: false,
    detectionSpeed: DetectionSpeed.noDuplicates,
    autoZoom: true,
  );
  bool _didReturnValue = false;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan Device ID',
          style: textTheme.titleLarge?.copyWith(
            fontSize: 30,
            color: AppColors.textColorDarkSecondary,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: MobileScanner(
        
        controller: _controller,
        onDetect: (result) {
          if (_didReturnValue) return;

          final value = result.barcodes.first.rawValue;
          if (value == null || value.isEmpty) return;

          _didReturnValue = true;
          _controller.stop();
          Navigator.pop(context, value);
        },
        tapToFocus: true,
      ),
    );
  }
}
