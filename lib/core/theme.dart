import 'dart:io';

import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

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

  static final _lightMaterial = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: appColor,
    ),
    inputDecorationTheme: _inputDecoration.copyWith(
      fillColor: Colors.white,
    ),
    useMaterial3: true,
  );

  static final _darkMaterial = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: appColor,
      brightness: Brightness.dark,
    ),
    inputDecorationTheme: _inputDecoration.copyWith(
      fillColor: Colors.grey[850],
    ),
    useMaterial3: true,
  );

  static final _lightMacos = MacosThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: appColor,
  );

  static final _darkMacos = MacosThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: appColor,
    brightness: Brightness.dark,
  );

  static final light = Platform.isMacOS ? _lightMacos : _lightMaterial;
  static final dark = Platform.isMacOS ? _darkMacos : _darkMaterial;
}
