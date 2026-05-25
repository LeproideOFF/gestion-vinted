import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'settings_provider.dart';

class AppTheme {
  static ThemeData getTheme(GlassTheme themeType, bool isDark) {
    final primary = ThemeColors.getPrimary(themeType);
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primary,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}
