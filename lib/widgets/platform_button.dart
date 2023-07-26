import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:todo_flutter/core/platform.dart';

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
    if (Platform.isLinux) {
      return textButton
          ? TextButton(
              onPressed: onPressed,
              child: Text(buttonTitle),
            )
          : ElevatedButton(
              onPressed: onPressed,
              child: Text(buttonTitle),
            );
    }

    if (Platform.isWindows) {
      return textButton
          ? fluent.HyperlinkButton(
              onPressed: onPressed,
              child: Text(buttonTitle),
            )
          : fluent.FilledButton(
              onPressed: onPressed,
              child: Text(buttonTitle),
            );
    }

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
