import 'package:aqua_nexis/app/app_theme.dart';
import 'package:aqua_nexis/app/provider/theme_mode_provider.dart';
import 'package:aqua_nexis/app/routes.dart';
import 'package:aqua_nexis/feature/auth/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AquaNexisApp extends StatefulWidget {
  const AquaNexisApp({super.key});

  @override
  State<AquaNexisApp> createState() => _AquaNexisAppState();
}

class _AquaNexisAppState extends State<AquaNexisApp> {
  final ThemeModeProvider _themeModeProvider = ThemeModeProvider();
  @override
  void initState() {
    super.initState();
    _themeModeProvider.setDefaultThemeMode();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _themeModeProvider),
        ],
      child: Consumer<ThemeModeProvider>(
        builder: (context, _, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Aqua Nexis',
            theme: AppTheme.darkTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _themeModeProvider.themeMode,
            initialRoute: SplashScreen.routeName,
            onGenerateRoute: AppRoutes.onGenerateRoute,
          );
        }
      ),
    );
  }
}
