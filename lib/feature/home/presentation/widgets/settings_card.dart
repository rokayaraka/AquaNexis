import 'package:flutter/material.dart';




class SettingsCard extends StatefulWidget {
  const SettingsCard({
    super.key,

  });

  @override
  State<SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
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
              Icons.settings,
              size: 70,
              color: Colors.cyan,
            ),
            const SizedBox(height: 8),
            const Text(
              "Settings",
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