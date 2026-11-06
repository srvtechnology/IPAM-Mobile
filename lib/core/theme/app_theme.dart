import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Institutional Colors
  static const Color emeraldDarker = Color(0xFF022C22);
  static const Color emeraldDeep = Color(0xFF044E3D);
  static const Color jadeAccent = Color(0xFF059669);
  static const Color jadeSoft = Color(0xFFE6F4EA);
  static const Color goldWarm = Color(0xFFD97706);
  static const Color goldLight = Color(0xFFFEF3C7);
  static const Color charcoal = Color(0xFF0F172A);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      cardColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: emeraldDeep,
        primary: emeraldDeep,
        secondary: jadeAccent,
        tertiary: goldWarm,
        surface: Colors.white,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: charcoal,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: GoogleFonts.manropeTextTheme().copyWith(
        displayLarge: GoogleFonts.libreCaslonText(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: charcoal,
        ),
        titleLarge: GoogleFonts.libreCaslonText(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: emeraldDeep,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF080C15),
      cardColor: const Color(0xFF0F172A),
      colorScheme: ColorScheme.fromSeed(
        seedColor: emeraldDeep,
        brightness: Brightness.dark,
        primary: jadeAccent,
        secondary: goldWarm,
        surface: const Color(0xFF0F172A),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: GoogleFonts.manropeTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.libreCaslonText(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.libreCaslonText(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  // Convenient aliases
  static ThemeData get light => lightTheme;
  static ThemeData get dark => darkTheme;
}
