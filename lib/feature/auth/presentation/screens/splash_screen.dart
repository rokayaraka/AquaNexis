import 'package:aqua_nexis/feature/auth/presentation/screens/sign_in_screen.dart';
import 'package:aqua_nexis/feature/auth/presentation/widgets/logo_animation.dart';
import 'package:flutter/material.dart';
import '../../../shared/widgets/customed_progress_indecator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = '/splash';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 4500), () {
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const .all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 200,
            children: [
              Spacer(),
              LogoAnimation(width: MediaQuery.of(context).size.width*.75 ),
              
              CustomedProgressIndecator(),
            ],
          ),
        ),
      ),
    );
  }
}
