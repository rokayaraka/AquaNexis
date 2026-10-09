import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../device_setup/presentation/screens/device_setup_screen.dart';

class DeviceSetupCard extends StatefulWidget {
  const DeviceSetupCard({super.key, required this.deviceStatus});
  final bool deviceStatus;

  @override
  State<DeviceSetupCard> createState() => _DeviceSetupCardState();
}

class _DeviceSetupCardState extends State<DeviceSetupCard> {
  @override
  Widget build(BuildContext context) {
    log("Device Status: ${widget.deviceStatus}");
    return GestureDetector(
      onTap: !widget.deviceStatus ? _onTap : null,
      child: Card(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.device_hub, size: 70, color: Colors.cyan),
              const SizedBox(height: 8),
              const Text(
                "Device Setup",
                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.deviceStatus ? "Device is online" : "Device is offline",
                style: TextStyle(
                  color: widget.deviceStatus
                      ? const Color.fromARGB(255, 215, 252, 84)
                      : Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap() {
    Navigator.pushNamed(context, DeviceSetupScreen.routeName);
  }
}
