import 'package:flutter/material.dart';

class LearningStyles {
  // Colors derived from Next.js Theme Config
  static const Color primaryGreen = Color(0xFF58CC02);
  static const Color primaryBlue = Color(0xFF1CB0F6);
  static const Color errorRed = Color(0xFFFF4B4B);
  static const Color successGreen = Color(0xFF58CC02);
  static const Color warningYellow = Color(0xFFFFC800);
  
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    fontFamily: 'Inter',
    letterSpacing: -0.5,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'Inter',
    color: Color(0xFF4B4B4B),
  );

  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Color(0xFFE5E5E5), width: 2),
  );
}
