import 'package:flutter/widgets.dart';
import 'package:native_context_menu/native_context_menu.dart';

class ContextMenu extends StatelessWidget {
  final Widget child;
  final void Function() onEdit;
  final void Function() onDelete;

  const ContextMenu({
    super.key,
    required this.child,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      onItemSelected: (item) {
        item.onSelected?.call();
      },
      menuItems: [
        MenuItem(
          title: 'Edit',
          onSelected: () => onEdit(),
        ),
        MenuItem(
          title: 'Remove',
          onSelected: () => onDelete(),
        )
      ],
      child: child,
    );
  }
}
