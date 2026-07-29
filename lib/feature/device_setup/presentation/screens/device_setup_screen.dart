import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';

class DeviceSetupScreen extends StatefulWidget {
  const DeviceSetupScreen({super.key});
  static const routeName = '/device-setup';
  @override
  State<DeviceSetupScreen> createState() => _DeviceSetupScreenState();
}

class _DeviceSetupScreenState extends State<DeviceSetupScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
     appBar: AppBar(
        backgroundColor: Color(0xFF0C3035),
        title:  Text('Device Setup',
          style:textTheme.titleMedium?.copyWith(
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
      body: const Center(
        child: Text('Device Setup Screen'),
      ),
    );
  }
}