import 'package:flutter/material.dart';
import 'package:todo_flutter/models/todo_model.dart';

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
    final color = isComplete ? Colors.grey[700] : Colors.white;

    return ListTile(
      leading: Icon(
        isComplete
            ? Icons.radio_button_checked_outlined
            : Icons.radio_button_unchecked_outlined,
        color: color,
      ),
      title: Text(
        widget.item.title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(color: color),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () {
        setState(() {
          isComplete = !isComplete;
        });

        widget.onTap?.call();
      },
    );
  }
}
