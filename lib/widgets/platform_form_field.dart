import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:todo_flutter/core/platform.dart';

class PlatformFormField extends StatelessWidget {
  final String? initialValue;
  final String hintText;
  final bool autofocus;
  final bool obscureText;
  final void Function(String) onChanged;

  const PlatformFormField({
    super.key,
    required this.onChanged,
    this.initialValue,
    required this.hintText,
    this.autofocus = false,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows) {
      return fluent.TextFormBox(
        initialValue: initialValue,
        placeholder: hintText,
        autofocus: autofocus,
        onChanged: onChanged,
        obscureText: obscureText,
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
      );
    }

    if (Platform.isMacOS) {
      return MacosTextField(
        controller: TextEditingController(text: initialValue),
        placeholder: hintText,
        autofocus: autofocus,
        onChanged: onChanged,
        obscureText: obscureText,
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
      );
    }

    if (Platform.isIOS) {
      return CupertinoTextField(
        controller: TextEditingController(text: initialValue),
        placeholder: hintText,
        autofocus: autofocus,
        onChanged: onChanged,
        obscureText: obscureText,
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
      );
    }

    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(hintText: hintText),
      autofocus: true,
      onChanged: onChanged,
      obscureText: obscureText,
    );
  }
}
