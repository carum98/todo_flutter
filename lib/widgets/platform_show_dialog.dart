import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:todo_flutter/core/platform.dart';

import 'dialog_macos.dart';

Future<T?> platformShowDialog<T>({
  required BuildContext context,
  required Widget Function() builder,
}) async {
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
