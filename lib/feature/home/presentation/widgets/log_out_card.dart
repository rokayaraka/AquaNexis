import 'package:flutter/material.dart';

import '../../../../core/storage/auth_storage.dart';
import '../../../auth/presentation/screens/sign_in_screen.dart';

class LogOutCard extends StatefulWidget {
  const LogOutCard({super.key});

  @override
  State<LogOutCard> createState() => _LogOutCardState();
}

class _LogOutCardState extends State<LogOutCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Card(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, size: 70, color: Colors.cyan),
              const SizedBox(height: 8),
              const Text(
                "Log Out",
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

  Future<void> _onTap() async {
    await AuthStorage.clear();
    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      SignInScreen.routeName,
      (route) => false,
    );
  }
}
