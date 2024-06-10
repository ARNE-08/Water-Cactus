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
          AppColors.lightBlue,
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          AppColors.white,
        ),
        shadowColor: MaterialStateProperty.all<Color>(
          Colors.transparent,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(45),
          ),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(
          GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
        fixedSize: MaterialStateProperty.all<Size>(
          const Size.fromHeight(50),
        ),
        elevation:
            MaterialStateProperty.all<double>(0), // Remove the elevation here
      ),
    ),
    textTheme: CustomTextTheme().textTheme,
    expansionTileTheme: const ExpansionTileThemeData(
      shape: Border(),
      backgroundColor: Colors.white,
    ),
  );
}

class CustomTextTheme {
  final Map<String, TextStyle> _customTextStyles = {
    'poppins1': GoogleFonts.poppins(
      textStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: Colors.black,
      ),
    ),
    'poppins2': GoogleFonts.poppins(
      textStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: Colors.black,
      ),
    ),
    'poppins3': GoogleFonts.poppins(
      textStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 10,
        color: AppColors.grey,
      ),
    ),
    'poppins4': GoogleFonts.poppins(
      textStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 10,
        color: AppColors.grey,
      ),
    ),
    'baloo1': GoogleFonts.balooThambi2(
      textStyle: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 20,
        color: AppColors.darkGrey,
      ),
    ),
    // Add more custom text styles as needed
  };

  TextTheme get textTheme => _buildTextTheme();

  TextTheme _buildTextTheme() {
    return TextTheme(
      headlineLarge: _customTextStyles['poppins1'],
      bodyLarge: _customTextStyles['poppins2'],
      bodyMedium: _customTextStyles['poppins3'],
      bodySmall: _customTextStyles['poppins4'],
      headlineMedium: _customTextStyles['baloo1'],
      // Add more mappings here
    );
  }
}
