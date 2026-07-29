import 'package:flutter/material.dart';


class MonitorCard extends StatefulWidget {
  const MonitorCard({
    super.key,

  });

  @override
  State<MonitorCard> createState() => _MonitorCardState();
}

class _MonitorCardState extends State<MonitorCard> {
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
              Icons.monitor_heart,
              size: 70,
              color: Colors.cyan,
            ),
            const SizedBox(height: 8),
            const Text(
              "Live Monitor",
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