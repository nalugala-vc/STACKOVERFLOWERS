import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';

class AppTheme {
  static _border([Color color = AppPallete.kenicGrey, double width = 3]) =>
      OutlineInputBorder(
        borderSide: BorderSide(color: color, width: width),
        borderRadius: BorderRadius.circular(7),
      );
  static final lightMode = ThemeData.light().copyWith(
    primaryColor: AppPallete.kenicRed,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(16),
      hintStyle: GoogleFonts.inter(
        color: AppPallete.kenicBlack,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      filled: true,
      fillColor: AppPallete.kenicGrey,
      errorStyle: GoogleFonts.inter(
        color: AppPallete.kenicRed,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      errorBorder: _border(AppPallete.kenicRed, 1),
      focusedBorder: _border(AppPallete.kenicGrey, 1),
      focusedErrorBorder: _border(AppPallete.kenicRed, 1),
      enabledBorder: _border(AppPallete.kenicGrey, 1),
    ),

    scaffoldBackgroundColor: AppPallete.kenicWhite,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 0,
    ),
  );
}
