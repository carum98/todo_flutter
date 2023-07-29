library list_scaffold;

import 'package:flutter/material.dart';
import 'package:todo_flutter/core/identifiable_interfaz.dart';
import 'package:todo_flutter/core/platform.dart';
import 'package:todo_flutter/core/repository_interfaz.dart';
import 'package:todo_flutter/widgets/context_menu.dart';
import 'package:todo_flutter/widgets/platform_show_dialog.dart';
import 'package:todo_flutter/widgets/swipe_actions.dart';

part '_controller.dart';
part '_actions.dart';
part '_divider.dart';
part '_list.dart';

class ListScaffold<T extends Identifiable, D> extends StatefulWidget {
  final List<T> items;
  final bool reorderable;
  final bool withDivider;
  final Repository<T, D> repository;
  final Widget Function(T item, int index) itemBuilder;
  final Widget Function(dynamic item) formBuilder;

  const ListScaffold({
    super.key,
    required this.items,
    this.reorderable = false,
    this.withDivider = false,
    required this.repository,
    required this.itemBuilder,
    required this.formBuilder,
  });

  @override
  State<ListScaffold<T, D>> createState() => _ListScaffoldState<T, D>();
}

class _ListScaffoldState<T extends Identifiable, D>
    extends State<ListScaffold<T, D>> {
  @override
  Widget build(BuildContext context) {
    return _Controller(
      state: this,
      child: _List<T>(
        items: widget.items,
        reorderable: widget.reorderable,
        itemBuilder: (item, index) {
          final key = ValueKey(item.id);

          return _Divider(
            key: key,
            isLast: index == widget.items.length - 1,
            enabled: widget.withDivider,
            child: _Actions<T>(
              key: key,
              item: item,
              index: index,
              child: widget.itemBuilder(item, index),
            ),
          );
        },
      ),
    );
  }
}
