// import 'package:aqua_nexis/feature/device_setup/presentation/screens/device_setup_screen.dart';
import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:wifi_connector/wifi_connector.dart';

import '../../../../app/app_colors.dart';

class AquaNexisWifiConnection extends StatefulWidget {
  const AquaNexisWifiConnection({super.key});

  @override
  State<AquaNexisWifiConnection> createState() =>
      _AquaNexisWifiConnectionState();
}

class _AquaNexisWifiConnectionState extends State<AquaNexisWifiConnection> {
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Wifi Setup",
                  style: textTheme.titleLarge?.copyWith(
                    color: AppColors.textColorDarkSecondary,
                  ),
                ),
                Text(
                  "Write SSID and password of your AquaNexis device",
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textColorDarkSecondary,
                  ),
                ),
                const SizedBox(height: 40.0),
                TextFormField(
                  controller: _ssidController,
                  decoration: InputDecoration(
                    labelText: 'SSID',
                    labelStyle: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textColorDarkSecondary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter SSID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textColorDarkSecondary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40.0),
                FilledButton(onPressed: _onTapConnect, child: Text('Connect')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapConnect() async {
    if (!_formKey.currentState!.validate()) return;
    // final ssid = _ssidController.text.trim();
    // final password = _passwordController.text;

    // final status = await Permission.location.request();
    // if (!status.isGranted) {
    //   return;
    // }

    // try {
    //   // using wifi_connector (API varies by plugin)
    //   final connected = await WifiConnector.connectToWifi(
    //     ssid: ssid,
    //     password: password,
    //     // plugin-specific options (security type, isWEP, etc.)
    //   );

    //   if (connected == true) {
    //     if (!mounted) return;
    //     Navigator.popAndPushNamed(context, DeviceSetupScreen.routeName);
    //     ScaffoldMessenger.of(
    //       context,
    //     ).showSnackBar(const SnackBar(content: Text('Connected')));
    //   } else {
    //     if (!mounted) return;
    //     ScaffoldMessenger.of(
    //       context,
    //     ).showSnackBar(const SnackBar(content: Text('Failed to connect')));
    //   }
    // } catch (e) {
    //   if (!mounted) return;
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(SnackBar(content: Text('Error: $e')));
    // }
  }
}
