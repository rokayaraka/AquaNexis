import 'package:aqua_nexis/app/app_colors.dart';
import 'package:aqua_nexis/app/constraints.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => _lightThemeData;
  static ThemeData get darkTheme => _darkThemeData;

  static final ThemeData _lightThemeData = ThemeData(
    colorSchemeSeed: AppColors.themeColorLight,
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.themeColorLight,
    ),
    scaffoldBackgroundColor: AppColors.themeColorLight,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.themeColorLight,
      titleTextStyle: TextStyle(
        fontSize: AppConstaints.titleLarge,
        color: AppColors.textColorLight,
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.textColorLight,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: AppColors.textColorLight,
        fontSize: AppConstaints.titleLarge,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: AppColors.textColorLight,
        fontSize: AppConstaints.titleMedium,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        color: AppColors.textColorLight,
        fontSize: AppConstaints.titleSmall,
        fontWeight: FontWeight.bold,
      ),
      labelLarge: TextStyle(
        fontSize: AppConstaints.lableLarge,
        color: AppColors.textColorLight,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        fontSize: AppConstaints.lableMedium,
        color: AppColors.textColorLight,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        fontSize: AppConstaints.lableSmall,
        color: AppColors.textColorLight,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontSize: AppConstaints.bodyLarge,
        color: AppColors.textColorLight,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        fontSize: AppConstaints.bodyMedium,
        color: AppColors.textColorLight,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontSize: AppConstaints.bodySmall,
        color: AppColors.textColorLight,
        fontWeight: FontWeight.w400,
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(0),
        foregroundColor: AppColors.errorColor,
        textStyle: TextStyle(
          fontSize: AppConstaints.bodyMedium,
        ),
      ),
    ),
    inputDecorationTheme: _inputDecorationThemeLight,
    filledButtonTheme: _filledButtonThemeLight,
  );

  static final FilledButtonThemeData _filledButtonThemeLight= FilledButtonThemeData(
    style:FilledButton.styleFrom(
      backgroundColor: AppColors.buttonColorLight,
      padding: const EdgeInsets.all(10),
      fixedSize: Size.fromWidth(double.maxFinite),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
  );
 static final FilledButtonThemeData _filledButtonThemeDark= FilledButtonThemeData(
    style:FilledButton.styleFrom(
      backgroundColor: AppColors.buttonColorDark,
      padding: const EdgeInsets.all(10),
      foregroundColor: Colors.white,
      fixedSize: Size.fromWidth(double.maxFinite),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
  );
  static final ThemeData _darkThemeData = ThemeData(
    colorSchemeSeed: AppColors.themeColorDark,
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.themeColorDark,
    ),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.themeColorDark,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.themeColorDark,
      titleTextStyle: TextStyle(
        fontSize: AppConstaints.titleLarge,
        color: AppColors.textColorDark,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(0),
        foregroundColor: Colors.blue,
        textStyle: TextStyle(
          fontSize: AppConstaints.bodyMedium,
          
        ),
      ),
    ),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        iconColor: MaterialStatePropertyAll<Color>(AppColors.textColorDark),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: AppConstaints.titleLarge,
        color: AppColors.textColorDark,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        fontSize: AppConstaints.titleMedium,
        color: AppColors.textColorDark,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: TextStyle(
        fontSize: AppConstaints.titleSmall,
        color: AppColors.textColorDark,
        fontWeight: FontWeight.bold,
      ),
      labelLarge: TextStyle(
        fontSize: AppConstaints.lableLarge,
        color: AppColors.textColorDark,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        fontSize: AppConstaints.lableMedium,
        color: AppColors.textColorDark,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        fontSize: AppConstaints.lableSmall,
        color: AppColors.textColorDark,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontSize: AppConstaints.bodyLarge,
        color: AppColors.textColorDark,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        fontSize: AppConstaints.bodyMedium,
        color: AppColors.textColorDark,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        fontSize: AppConstaints.bodySmall,
        color: AppColors.textColorDark,
        fontWeight: FontWeight.w400,
      ),
    ),
    inputDecorationTheme: _inputDecorationThemeDark,
    filledButtonTheme: _filledButtonThemeDark,
  );

  static final _inputDecorationThemeDark = InputDecorationThemeData(
    contentPadding: EdgeInsets.only(left: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: AppColors.borderPrimaryColor, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: AppColors.borderPrimaryColor, width: 1),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: AppColors.borderPrimaryColor, width: 1),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: AppColors.errorColor, width: 1),
    ),
  );
  static final _inputDecorationThemeLight = InputDecorationThemeData(
    contentPadding: EdgeInsets.only(left: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: AppColors.borderPrimaryColor, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: AppColors.borderPrimaryColor, width: 1),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: AppColors.borderPrimaryColor, width: 1),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: AppColors.errorColor, width: 1),
    ),
  );
}
