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
          AppColors.water,
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
    expansionTileTheme: const ExpansionTileThemeData(
      shape: Border(),
      backgroundColor: Colors.white,
    ),
  );
}

class CustomTextStyle {
  static final TextStyle poppins1 = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 24,
      color: AppColors.black,
    ),
  );

  static final TextStyle poppins2 = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 12,
      color: AppColors.black,
    ),
  );

  static final TextStyle poppins3 = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 10,
      color: AppColors.grey,
    ),
  );

  static final TextStyle poppins4 = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 10,
      color: AppColors.grey,
    ),
  );

    static final TextStyle poppins5 = GoogleFonts.poppins(
    textStyle: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: AppColors.black,
    ),
  );

  static final TextStyle baloo1 = GoogleFonts.balooThambi2(
    textStyle: const TextStyle(
      fontWeight: FontWeight.w800,
      fontSize: 20,
      color: AppColors.darkGrey,
    ),
  );
}
