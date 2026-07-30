import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_colors.dart';
import '../providers/ssid_provider.dart';
import '../widgets/aqua_nexis_wifi_connection.dart';
import '../widgets/connect_local_router.dart';

class DeviceSetupScreen extends StatefulWidget {
  const DeviceSetupScreen({super.key});
  static const routeName = '/device-setup';
  @override
  State<DeviceSetupScreen> createState() => _DeviceSetupScreenState();
}

class _DeviceSetupScreenState extends State<DeviceSetupScreen> {
  final ssidProvider = SsidProvider();
  @override
  void initState() {
    super.initState();
    getConnectedSsid().then((ssid) {
      ssidProvider.setSsid(ssid);
    });
  }

  Future<String?> getConnectedSsid() async {
    final status = await Permission.location.request();
    if (!status.isGranted) return null;
    final info = NetworkInfo();
    final ssid = await info.getWifiName();
    return ssid;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0C3035),
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ChangeNotifierProvider.value(
        value: ssidProvider,
        child: ssidProvider.ssid == "AquaNexis"
            ? const ConnectLocalRouter()
            : const AquaNexisWifiConnection(),
      ),
    );
  }
}
