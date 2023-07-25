import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:todo_flutter/core/platform.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import 'dialog_macos.dart';

Future<T?> platformShowDialog<T>({
  required BuildContext context,
  required Widget Function() builder,
}) async {
  if (Platform.isLinux) {
    return await showDialog(
      context: context,
      builder: (_) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 400,
            maxWidth: 400,
          ),
          child: builder(),
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

  return await showDialog(
    context: context,
    builder: (_) => Dialog(
      child: builder(),
    ),
  );
}
