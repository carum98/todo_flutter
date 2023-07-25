import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:todo_flutter/core/platform.dart';
import 'package:todo_flutter/models/todo_model.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class ToDoTile extends StatefulWidget {
  final TodoModel item;
  final VoidCallback? onTap;

  const ToDoTile({super.key, required this.item, this.onTap});

  @override
  State<ToDoTile> createState() => _ToDoTileState();
}

class _ToDoTileState extends State<ToDoTile> {
  late bool isComplete;

  @override
  void initState() {
    super.initState();

    isComplete = widget.item.completed;
  }

  @override
  Widget build(BuildContext context) {
    final color = isComplete ? Colors.grey[500] : null;
    final icon =
        isComplete ? Icons.radio_button_checked : Icons.radio_button_unchecked;

    void onTap() {
      setState(() {
        isComplete = !isComplete;
      });

      widget.onTap?.call();
    }

    if (Platform.isWindows) {
      return fluent.ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          widget.item.title,
          style: fluent.FluentThemeData.dark()
              .typography
              .bodyLarge!
              .copyWith(color: color),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: onTap,
      );
    }

    if (Platform.isMacOS) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: MacosListTile(
          leading: Icon(icon, color: color),
          title: Text(
            widget.item.title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: color ?? Colors.white),
          ),
          onClick: onTap,
        ),
      );
    }

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        widget.item.title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(color: color),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: onTap,
    );
  }
}
