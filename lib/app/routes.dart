import 'package:aqua_nexis/feature/auth/presentation/screens/sign_in_screen.dart';
import 'package:aqua_nexis/feature/auth/presentation/screens/sign_up_screen.dart';
import 'package:aqua_nexis/feature/auth/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';

import '../feature/auth/presentation/screens/scan_device_id_screen.dart';
import '../feature/device_setup/presentation/screens/device_setup_screen.dart';
import '../feature/home/presentation/screens/home_screen.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case SignInScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case SignUpScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case ScanDeviceIdScreen.routeName:
        return MaterialPageRoute<String?>(
          builder: (_) => const ScanDeviceIdScreen(),
        );
      case HomeScreen.routeName:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case DeviceSetupScreen.routeName:
        return MaterialPageRoute(builder: (_) => const DeviceSetupScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SizedBox());
    }
  }
}