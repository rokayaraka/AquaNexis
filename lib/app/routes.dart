import 'package:aqua_nexis/feature/auth/presentation/screens/sign_in_screen.dart';
import 'package:aqua_nexis/feature/auth/presentation/screens/sign_up_screen.dart';
import 'package:aqua_nexis/feature/auth/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes{

  static Route<dynamic>onGenerateRoute(RouteSettings settings){

    Widget widget=SizedBox();
    switch(settings.name){
      case SplashScreen.routeName:
        widget=SplashScreen();
      case SignInScreen.routeName:
        widget=SignInScreen();
      case SignUpScreen.routeName:
        widget=SignUpScreen();
    }
    return MaterialPageRoute(builder: (_)=>widget);
  }
}