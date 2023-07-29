part of 'list_scaffold.dart';

class _Actions<T extends Identifiable> extends StatelessWidget {
  final T item;
  final int index;
  final Widget child;

  const _Actions({
    super.key,
    required this.item,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final controller = _Controller.of<T>(context);

    return Platform.isDesktop
        ? ContextMenu(
            child: child,
            onDelete: () async => {
              await controller?.deleteConfirmation(),
              controller?.delete(item, index)
            },
            onEdit: () => controller?.edit(item, index),
          )
        : SwipeActions(
            keyAction: ValueKey(item.id),
            confirmDismiss: controller?.deleteConfirmation ?? () async => false,
            onEdit: () => controller?.edit(item, index),
            onDelete: () => controller?.delete(item, index),
            child: child,
          );
  }
}
