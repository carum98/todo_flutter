import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:todo_flutter/core/platform.dart';

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

  static final _buttonStyleWindows = fluent.ButtonThemeData(
    filledButtonStyle: fluent.ButtonStyle(
      padding: fluent.ButtonState.all(
        const EdgeInsets.symmetric(
          vertical: 10,
        ),
      ),
    ),
  );

  static final _lightWindows = fluent.FluentThemeData(
    brightness: Brightness.light,
    accentColor: fluent.AccentColor('normal', appColor.toAccentColor().swatch),
    buttonTheme: _buttonStyleWindows,
  );

  static final _darkWindows = fluent.FluentThemeData(
    brightness: Brightness.dark,
    accentColor: fluent.AccentColor('normal', appColor.toAccentColor().swatch),
    buttonTheme: _buttonStyleWindows,
  );

  static const _darkIOS = CupertinoThemeData(
    // brightness: Brightness.dark,
    primaryColor: appColor,
    applyThemeToAll: true,
  );

  static final light = Platform.isWindows
      ? _lightWindows
      : Platform.isMacOS
          ? _lightMacos
          : _lightMaterial;

  static final dark = Platform.isWindows
      ? _darkWindows
      : Platform.isMacOS
          ? _darkMacos
          : Platform.isIOS
              ? _darkIOS
              : _darkMaterial;
}
