import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00BCD4), // Cyan for primary actions
        onPrimary: Colors.white,
        surface: Color(0xFF212121), // Dark grey for backgrounds
        onSurface: Colors.white, // White text/icons on dark surfaces
        secondary: Color(0xFFBB86FC), // Purple for secondary actions
        onSecondary: Colors.black,
        background: Color(0xFF121212), // Darker background for the app
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
      ),
      cardTheme: CardTheme(
        color: Colors.white.withOpacity(0.1),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(24),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF00BCD4), // Cyan for primary actions
        onPrimary: Colors.white,
        surface: Color(0xFFF5F5F5), // Light grey for backgrounds
        onSurface: Colors.black87, // Dark text/icons on light surfaces
        secondary: Color(0xFFBB86FC), // Purple for secondary actions
        onSecondary: Colors.white,
        background: Colors.white, // White background for the app
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
        displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.black54),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
      ),
      cardTheme: CardTheme(
        color: Colors.black.withOpacity(0.05),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00BCD4), // Cyan button background
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(24),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}