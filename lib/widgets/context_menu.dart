import 'package:flutter/widgets.dart';
import 'package:native_context_menu/native_context_menu.dart';

class ContextMenu extends StatelessWidget {
  final Widget child;
  const ContextMenu({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      onItemSelected: (item) {
        item.onSelected?.call();
      },
      menuItems: [
        MenuItem(
          title: 'Edit',
          onSelected: () => print('edit'),
        ),
        MenuItem(
          title: 'Remove',
          onSelected: () => print('remove'),
        )
      ],
      child: child,
    );
  }
}
