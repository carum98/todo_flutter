import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class DialogMacos extends StatelessWidget {
  final Widget child;
  const DialogMacos({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final brightness = MacosTheme.brightnessOf(context);
    const kDialogBorderRadius = BorderRadius.all(Radius.circular(12.0));
    const kDefaultDialogConstraints = BoxConstraints(
      minWidth: 260,
      maxWidth: 260,
    );

    final outerBorderColor = brightness.resolve(
      Colors.black.withOpacity(0.23),
      Colors.black.withOpacity(0.76),
    );

    final innerBorderColor = brightness.resolve(
      Colors.white.withOpacity(0.45),
      Colors.white.withOpacity(0.15),
    );

    return Dialog(
      backgroundColor: brightness.resolve(
        CupertinoColors.systemGrey6.color,
        MacosColors.controlBackgroundColor.darkColor,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: kDialogBorderRadius,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: innerBorderColor,
          ),
          borderRadius: kDialogBorderRadius,
        ),
        foregroundDecoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: outerBorderColor,
          ),
          borderRadius: kDialogBorderRadius,
        ),
        child: ConstrainedBox(
          constraints: kDefaultDialogConstraints,
          child: child,
        ),
      ),
    );
  }
}
