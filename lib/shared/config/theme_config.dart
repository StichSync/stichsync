import 'package:flutter/material.dart';

class ThemeConfig {
  // colors
  static const Color _primaryColor = Colors.deepPurple;

  static ThemeData themeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _primaryColor,
    ),
    useMaterial3: true,
  );

  // animations
  static const Duration buttonDuration = Duration(milliseconds: 150);
  static const Curve buttonCurve = Curves.easeInOut;
}
