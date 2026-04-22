import 'package:flutter/material.dart';

class SalonTheme {
  static const Color primary = Color(0xFF8C4D53);
  static const Color primaryContainer = Color(0xFFFFAEB4);
  static const Color secondary = Color(0xFF785A29);
  static const Color surface = Color(0xFFFCF9F8);
  static const Color onSurface = Color(0xFF323232);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: surface,
        onSurface: onSurface,
        primaryContainer: primaryContainer,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'NotoSerif',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: onSurface,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 16,
          color: onSurface,
        ),
      ),
    );
  }
}
