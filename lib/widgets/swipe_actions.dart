import 'package:flutter/material.dart';
import 'package:todo_flutter/widgets/platform_show_dialog.dart';

class SwipeActions extends StatelessWidget {
  final ValueKey<int> keyAction;
  final Widget child;
  final Function() onEdit;
  final Function() onDelete;

  const SwipeActions({
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

        return platformShowDialogAlert(
          context: context,
          title: 'Delete',
          content: 'Are you sure?',
        );
      },
      child: child,
    );
  }
}
