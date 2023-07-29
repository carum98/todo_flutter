import 'package:flutter/material.dart';

class SwipeActions extends StatelessWidget {
  final ValueKey<int> keyAction;
  final Widget child;
  final void Function() onEdit;
  final void Function() onDelete;
  final Future<bool> Function() confirmDismiss;

  const SwipeActions({
    super.key,
    required this.keyAction,
    required this.child,
    required this.onEdit,
    required this.onDelete,
    required this.confirmDismiss,
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

        return await confirmDismiss();
      },
      child: child,
    );
  }
}
