import 'package:flutter/material.dart';

class AppTheme {
  // Brand color palette:
  // Black Pine:  #152026
  // Deep Ocean:  #1B3D59
  // Windstorm:   #6A97C0
  // Melting Ice: #B3D5F1
  // Avalanche:   #D4EEF8
  // Sun Beam:    #F3EED8

  static const Color blackPine = Color(0xFF152026);
  static const Color deepOcean = Color(0xFF1B3D59);
  static const Color windstorm = Color(0xFF6A97C0);
  static const Color meltingIce = Color(0xFFB3D5F1);
  static const Color avalanche = Color(0xFFD4EEF8);
  static const Color sunBeam = Color(0xFFF3EED8);

  // Semantics & Surfacing
  static const Color backgroundLight = Color(0xFFF0F7FB);
  static const Color surfaceLight = Colors.white;
  static const Color textDark = blackPine;
  static const Color textMuted = Color(0xFF4C6B7E);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: deepOcean,
      brightness: Brightness.light,
      primary: deepOcean,
      secondary: windstorm,
      tertiary: sunBeam,
      surface: surfaceLight,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundLight,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: deepOcean),
        titleTextStyle: TextStyle(
          color: blackPine,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: meltingIce.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        hintStyle: const TextStyle(
          color: textMuted,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: meltingIce.withValues(alpha: 0.6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: meltingIce.withValues(alpha: 0.6)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: deepOcean, width: 1.8),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: deepOcean,
        foregroundColor: sunBeam,
        elevation: 4,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.w800,
          color: blackPine,
          letterSpacing: -1.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: blackPine,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: blackPine,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: blackPine,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          color: blackPine,
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          color: textMuted,
        ),
      ),
    );
  }
}
