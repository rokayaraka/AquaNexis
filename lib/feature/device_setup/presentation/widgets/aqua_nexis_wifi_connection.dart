import 'package:flutter/material.dart';


import '../../../../app/app_colors.dart';
import '../../data/models/wifi_credentials.dart';

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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                "Provide your Home Wifi credentials to connect your device to the internet.",
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
              const SizedBox(height: 20.0),
              FilledButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text('Cancel')),
            ],
          ),
        ),
      ),
    );
  }

  void _onTapConnect() async {
    if (!_formKey.currentState!.validate()) return;
    return Navigator.of(context).pop(WifiCredentials(
      ssid: _ssidController.text,
      password: _passwordController.text,
      server: "",
      deviceId: "",
    ));
  }
}
