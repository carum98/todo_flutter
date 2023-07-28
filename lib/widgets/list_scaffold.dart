import 'package:flutter/material.dart';
import 'package:todo_flutter/core/repository_interfaz.dart';

import 'platform_show_dialog.dart';
import 'swipe_actions.dart';

class ListScaffold<T, D> extends StatefulWidget {
  final List<T> items;
  final bool reorderable;
  final bool withDivider;
  final Repository<T, D> repository;
  final Widget Function(T item, int index) itemBuilder;
  final Widget Function(T item) formBuilder;
  final int Function(T item) indentifierBuilder;

  const ListScaffold({
    super.key,
    required this.items,
    this.reorderable = false,
    this.withDivider = false,
    required this.repository,
    required this.itemBuilder,
    required this.formBuilder,
    required this.indentifierBuilder,
  });

  @override
  State<ListScaffold<T, D>> createState() => _ListScaffoldState<T, D>();
}

class _ListScaffoldState<T, D> extends State<ListScaffold<T, D>> {
  @override
  Widget build(BuildContext context) {
    return _ListBuilder<T>(
      items: widget.items,
      reorderable: widget.reorderable,
      onMove: onMove,
      itemBuilder: (item, index) {
        final key = ValueKey(widget.indentifierBuilder(item));

        return TileDivider(
          key: key,
          isLast: index == widget.items.length - 1,
          enabled: widget.withDivider,
          child: SwipeActions(
            keyAction: key,
            onDelete: () => onDelete(item, index),
            onEdit: () => onEdit(item, index),
            child: widget.itemBuilder(item, index),
          ),
        );
      },
    );
  }

  Future<void> onMove(int oldIndex, int newIndex) async {
    final index = newIndex > oldIndex ? newIndex - 1 : newIndex;
    final item = widget.items[oldIndex];

    setState(() {
      widget.items.removeAt(oldIndex);
      widget.items.insert(index, item);
    });

    widget.repository
        .move(widget.indentifierBuilder(item), newIndex)
        .onError((_, __) {
      setState(() {
        widget.items.removeAt(index);
        widget.items.insert(oldIndex, item);
      });
    });
  }

  Future<void> onDelete(T item, int index) async {
    await widget.repository.delete(widget.indentifierBuilder(item));

    widget.items.removeAt(index);
  }

  Future<void> onEdit(T item, int index) async {
    final data = await platformShowDialog(
      context: context,
      builder: () => widget.formBuilder(item),
    );

    if (data == null) return;

    widget.items.removeAt(index);
    widget.items.insert(index, data);

    setState(() {});
  }
}

class _ListBuilder<T> extends StatelessWidget {
  final List<T> items;
  final bool reorderable;
  final Future<void> Function(int, int) onMove;
  final Widget Function(T, int) itemBuilder;

  const _ListBuilder({
    super.key,
    required this.items,
    required this.reorderable,
    required this.itemBuilder,
    required this.onMove,
  });

  @override
  Widget build(BuildContext context) {
    if (reorderable) {
      return ReorderableListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: items.length,
        onReorder: onMove,
        itemBuilder: (_, index) {
          final item = items[index];

          return itemBuilder(item, index);
        },
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];

          return itemBuilder(item, index);
        },
      );
    }
  }
}

class TileDivider extends StatelessWidget {
  final Widget child;
  final bool isLast;
  final bool enabled;

  const TileDivider({
    super.key,
    required this.child,
    required this.isLast,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      decoration: enabled
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isLast ? Colors.transparent : Colors.grey,
                  width: 0.5,
                ),
              ),
            )
          : null,
      child: child,
    );
  }
}
