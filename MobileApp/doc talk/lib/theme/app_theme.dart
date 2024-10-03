import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.lightGray,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryBlue,
      secondary: AppColors.primaryTeal,
      background: AppColors.lightGray,
      error: AppColors.errorRed,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: AppColors.darkGray,
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: AppColors.darkGray,
        fontSize: 16.0,
      ),
      bodyMedium: TextStyle(
        color: AppColors.lightGray,
        fontSize: 14.0,
      ),
      labelLarge: TextStyle(
        color: AppColors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.primaryBlue,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.darkPrimaryBlue,
    scaffoldBackgroundColor: AppColors.darkGrayBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimaryBlue,
      secondary: AppColors.darkPrimaryTeal,
      background: AppColors.darkGrayBackground,
      surface: AppColors.darkSurface,
      error: AppColors.errorRed,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: AppColors.darkText,
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: AppColors.darkText,
        fontSize: 16.0,
      ),
      bodyMedium: TextStyle(
        color: AppColors.darkText,
        fontSize: 14.0,
      ),
      labelLarge: TextStyle(
        color: AppColors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.darkPrimaryBlue,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
