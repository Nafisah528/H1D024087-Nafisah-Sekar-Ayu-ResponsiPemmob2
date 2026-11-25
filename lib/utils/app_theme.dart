import 'package:flutter/material.dart';

class AppTheme {
  // Brand color palette (Winter Palette):
  // 1. Black Pine:  #152026
  // 2. Deep Ocean:  #1B3D59
  // 3. Windstorm:   #6A97C0
  // 4. Melting Ice: #B3D5F1
  // 5. Avalanche:   #D4EEF8
  // 6. Sun Beam:    #F3EED8

  static const Color blackPine = Color(0xFF152026);
  static const Color deepOcean = Color(0xFF1B3D59);
  static const Color windstorm = Color(0xFF6A97C0);
  static const Color meltingIce = Color(0xFFB3D5F1);
  static const Color avalanche = Color(0xFFD4EEF8);
  static const Color sunBeam = Color(0xFFF3EED8);

  // Surface and text colors based on the palette (no plain white)
  static const Color backgroundLight = avalanche; // #D4EEF8
  static const Color cardSurface = Color(0xFFE2EFF9); // Tinted with Melting Ice & Avalanche
  static const Color textDark = blackPine; // #152026
  static const Color textSecondary = deepOcean; // #1B3D59
  static const Color textMuted = Color(0xFF385A75); // Deeper Windstorm tone

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: deepOcean,
      brightness: Brightness.light,
      primary: deepOcean,
      secondary: windstorm,
      tertiary: sunBeam,
      surface: cardSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: avalanche,
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
        color: cardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: windstorm.withValues(alpha: 0.4),
            width: 1.2,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        hintStyle: TextStyle(
          color: textMuted.withValues(alpha: 0.7),
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: windstorm.withValues(alpha: 0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: windstorm.withValues(alpha: 0.5)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: deepOcean, width: 2),
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
          fontWeight: FontWeight.w700,
          color: blackPine,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          color: blackPine,
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          color: textSecondary,
        ),
      ),
    );
  }
}
