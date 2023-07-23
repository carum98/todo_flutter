import 'package:flutter/material.dart';

class ThemeController {
  static const appColor = Color(0xFF0070F3);

  static final _inputDecoration = InputDecorationTheme(
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 10,
    ),
  );

  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: appColor,
    ),
    inputDecorationTheme: _inputDecoration.copyWith(
      fillColor: Colors.white,
    ),
    useMaterial3: true,
  );

  static final dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: appColor,
      brightness: Brightness.dark,
    ),
    inputDecorationTheme: _inputDecoration.copyWith(
      fillColor: Colors.grey[850],
    ),
    useMaterial3: true,
  );
}
