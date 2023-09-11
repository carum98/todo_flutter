import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:todo_flutter/core/platform.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import 'dialog_macos.dart';

Future<T?> platformShowDialog<T>({
  required BuildContext context,
  required Widget Function() builder,
}) async {
  if (Platform.isLinux || Platform.isWeb) {
    return await showDialog(
      context: context,
      builder: (_) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 400,
            maxWidth: 400,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: builder(),
          ),
        ),
      ),
    );
  }

  if (Platform.isWindows) {
    return await fluent.showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => fluent.ContentDialog(
        content: builder(),
      ),
    );
  }

  if (Platform.isMacOS) {
    return await showMacosAlertDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => DialogMacos(
        child: builder(),
      ),
    );
  }

  if (Platform.isIOS) {
    return await showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => CupertinoAlertDialog(
        content: builder(),
      ),
    );
  }

  return await showDialog(
    context: context,
    builder: (_) => Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: builder(),
      ),
    ),
  );
}

Future<T?> platformShowDialogAlert<T>({
  required BuildContext context,
  required String title,
  required String content,
  String confirmTitle = 'Yes',
  String cancelTitle = 'No',
}) {
  if (Platform.isWindows) {
    return fluent.showDialog(
      context: context,
      builder: (_) => fluent.ContentDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          fluent.Button(
            child: Text(confirmTitle),
            onPressed: () => Navigator.pop(context, true),
          ),
          fluent.FilledButton(
            onPressed: () => Navigator.pop(context, false),
            style: fluent.ButtonStyle(
              padding: fluent.ButtonState.all(
                const EdgeInsets.symmetric(vertical: 6),
              ),
            ),
            child: Text(cancelTitle),
          ),
        ],
      ),
    );
  }

  if (Platform.isLinux) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 150,
            maxWidth: 150,
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                Text(
                  content,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(cancelTitle),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(confirmTitle),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  if (Platform.isMacOS) {
    return showMacosAlertDialog(
      context: context,
      builder: (_) => MacosAlertDialog(
        appIcon: const MacosIcon(
          CupertinoIcons.trash_fill,
          size: 64,
          color: Colors.grey,
        ),
        title: Text(
          title,
          style: MacosTheme.of(context).typography.headline,
        ),
        message: Text(
          content,
          textAlign: TextAlign.center,
          style: MacosTypography.of(context).headline,
        ),
        primaryButton: PushButton(
          controlSize: ControlSize.large,
          child: Text(confirmTitle),
          onPressed: () => Navigator.pop(context, true),
        ),
        secondaryButton: PushButton(
          controlSize: ControlSize.large,
          secondary: true,
          child: Text(cancelTitle),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
    );
  }

  if (Platform.isIOS) {
    return showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, false),
            isDefaultAction: true,
            child: Text(cancelTitle),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmTitle),
          ),
        ],
      ),
    );
  }

  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelTitle),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmTitle),
        ),
      ],
    ),
  );
}
