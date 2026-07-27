import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeProvider extends ChangeNotifier {
   ThemeMode _currentThemeMode = ThemeMode.dark;

   ThemeMode get themeMode => _currentThemeMode;

   void changeThemeMode(ThemeMode mode) {
     _currentThemeMode = mode;
     _saveThemeMode(mode);
     print('Theme mode changed to: ${mode.name}');
     notifyListeners();
   }

   Future<void> _saveThemeMode(ThemeMode mode) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('themeMode', mode.name);
   }
   Future<void> setDefaultThemeMode() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? themeMode =   sharedPreferences.getString('themeMode');
    if (themeMode != null) {
      print('Retrieved theme mode from SharedPreferences: $themeMode');
      _currentThemeMode = _parseThemeMode(themeMode);
      notifyListeners();
    }
   }

   ThemeMode _parseThemeMode(String themeMode) {
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.dark;
    }

 }
 }