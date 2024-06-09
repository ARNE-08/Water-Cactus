import 'package:flutter/material.dart';
import 'color_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData get customTheme {
    return _customTheme;
  }

  static final ThemeData _customTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Poppins",
    scaffoldBackgroundColor: AppColors.lightBlue,
    primaryColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        AppColors.blue,
      ),
      foregroundColor: MaterialStateProperty.all<Color>(
        AppColors.white,
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.5),
        ),
      ),
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 18,
          color: AppColors.white,
        ),
      ),
      fixedSize: MaterialStateProperty.all<Size>(
        const Size.fromHeight(50),
      ),
      elevation:
          MaterialStateProperty.all<double>(0), // Remove the elevation here
    )),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 40, color: AppColors.darkGrey),
      headlineMedium: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 20, color: AppColors.darkGrey),
      headlineSmall: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 20, color: AppColors.darkGrey),
      bodyLarge: TextStyle(
          fontWeight: FontWeight.w500, fontSize: 20, color: AppColors.darkGrey),
      bodyMedium: TextStyle(
          fontWeight: FontWeight.w500, fontSize: 18, color: AppColors.darkGrey),
      bodySmall: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 14, color: AppColors.darkGrey),
    ),
    expansionTileTheme: const ExpansionTileThemeData(
        shape: Border(), backgroundColor: Colors.white),
  );
}
