import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/core/platform.dart';
import 'package:todo_flutter/models/list_model.dart';
import 'package:todo_flutter/router/router_name.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class ListsTile extends StatelessWidget {
  final ListModel item;
  const ListsTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final color = Stack(
      alignment: Alignment.center,
      children: [
        const Icon(Icons.circle, color: Colors.white, size: 20),
        Icon(Icons.circle, color: item.color, size: 18),
      ],
    );

    final title = Text(
      item.name,
      style: Theme.of(context).textTheme.titleLarge,
    );

    onTap() {
      Navigator.pushNamed(context, TODO_PAGE, arguments: item.id);
    }

    if (Platform.isIOS) {
      return CupertinoListTile(
        leading: color,
        leadingToTitle: 5,
        padding: const EdgeInsets.all(10),
        title: Text(
          item.name,
          style: CupertinoTheme.of(context)
              .textTheme
              .textStyle
              .copyWith(fontSize: 18),
        ),
        backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
        trailing: const CupertinoListTileChevron(),
        onTap: onTap,
      );
    }

    if (Platform.isWindows) {
      return fluent.ListTile(
        leading: color,
        title: title,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: onTap,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: color,
        title: title,
        tileColor: Theme.of(context).colorScheme.surfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onTap: onTap,
      ),
    );
  }
}
