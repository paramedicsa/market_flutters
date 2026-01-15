import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color shockingPink = Color(0xFFFF0080);
  static const Color pink = shockingPink; // Alias for backwards compatibility
  static const Color cyan = Color(0xFF00FFFF);
  static const Color purple = Color(0xFF9D00FF);
  static const Color black = Color(0xFF000000);
  static const Color cardDark = Color(0xFF1A1A1A);
  static const Color cardBorder = Color(0xFF2A2A2A);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: black,
      primaryColor: shockingPink,
      colorScheme: const ColorScheme.dark(
        primary: shockingPink,
        secondary: cyan,
        tertiary: purple,
        surface: cardDark,
      ),
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 12,
        shadowColor: shockingPink.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: cardBorder,
            width: 1,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: black,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: shockingPink,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: cyan),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: shockingPink,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: shockingPink,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: shockingPink.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
      fontFamily: 'Roboto',
    );
  }

  // Custom gradient for cards
  static LinearGradient cardGradient(Color color) {
    return LinearGradient(
      colors: [
        color.withValues(alpha: 0.2),
        color.withValues(alpha: 0.05),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // Shadow for elevated cards
  static List<BoxShadow> cardShadow(Color color) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.3),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.5),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }
}
