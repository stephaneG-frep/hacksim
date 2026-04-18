import 'package:flutter/material.dart';

class AppTheme {
  static const Color bg = Color(0xFF0A1016);
  static const Color panel = Color(0xFF121C26);
  static const Color panelAlt = Color(0xFF182838);
  static const Color accent = Color(0xFF00E5A8);
  static const Color warning = Color(0xFFFFC857);
  static const Color danger = Color(0xFFFF6B6B);

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: warning,
        surface: panel,
        error: danger,
      ),
      cardTheme: const CardThemeData(
        color: panel,
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 8),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
        fontFamily: 'monospace',
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: panelAlt,
        border: OutlineInputBorder(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        side: const BorderSide(color: accent),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
