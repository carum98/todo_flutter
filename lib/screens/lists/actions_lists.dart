import 'package:flutter/material.dart';

class ActionsLists extends StatelessWidget {
  final ValueKey<int> keyAction;
  final Widget child;
  final Function() onEdit;
  final Function() onDelete;

  const ActionsLists({
    super.key,
    required this.keyAction,
    required this.child,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      secondaryBackground: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(right: 20),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ],
        ),
      ),
      background: Container(
        color: Colors.blue,
        padding: const EdgeInsets.only(left: 20),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ],
        ),
      ),
      key: keyAction,
      onDismissed: (DismissDirection direction) async {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onEdit();

          return Future.value(false);
        }

        return showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Delete'),
            content: const Text('Are you sure?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      },
      child: child,
    );
  }
}
