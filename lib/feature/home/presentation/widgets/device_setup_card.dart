import 'package:flutter/material.dart';



class DeviceSetupCard extends StatefulWidget {
  const DeviceSetupCard({
    super.key,

  });

  @override
  State<DeviceSetupCard> createState() => _DeviceSetupCardState();
}

class _DeviceSetupCardState extends State<DeviceSetupCard> {
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: _onTap,
      child: Card(
        child: Center(
          child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.device_hub,
              size: 70,
              color: Colors.cyan,
            ),
            const SizedBox(height: 8),
            const Text(
              "Device Setup",
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  void _onTap() {
  }
}