import 'dart:io';

import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class PlatformButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonTitle;
  final bool textButton;

  const PlatformButton({
    super.key,
    required this.onPressed,
    required this.buttonTitle,
    this.textButton = false,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isMacOS) {
      return PushButton(
        onPressed: onPressed,
        controlSize: ControlSize.large,
        secondary: textButton,
        child: Text(buttonTitle),
      );
    }

    return textButton
        ? TextButton(
            onPressed: onPressed,
            child: Text(buttonTitle),
          )
        : FilledButton(
            onPressed: onPressed,
            child: Text(buttonTitle),
          );
  }
}
