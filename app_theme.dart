import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Calm, Ramadan-inspired colors
  static const Color sageGreen = Color(0xFF8DAA91);
  static const Color softCream = Color(0xFFF9F6F0);
  static const Color mutedGold = Color(0xFFD4AF37);
  static const Color deepTwilight = Color(0xFF2C3E50);
  static const Color softGlowGold = Color(0xFFFFD700);
  static const Color dimGlowBlue = Color(0xFFADD8E6);

  static TextStyle get arabicStyle => GoogleFonts.amiri(
        fontSize: 28,
        height: 1.4,
        color: deepTwilight,
      );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: sageGreen,
        surface: softCream,
      ),
      scaffoldBackgroundColor: softCream,
      textTheme: GoogleFonts.quicksandTextTheme(
        TextTheme(
          displayLarge: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: deepTwilight,
          ),
          bodyLarge: const TextStyle(
            fontSize: 18,
            color: deepTwilight,
          ),
          bodyMedium: const TextStyle(
            fontSize: 16,
            color: deepTwilight,
          ),
        ),
      ),
    );
  }
}
