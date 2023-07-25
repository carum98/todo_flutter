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
    if (Platform.isWindows) {
      return fluent.ListTile(
        leading: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.circle, color: Colors.white, size: 20),
            Icon(Icons.circle, color: item.color, size: 18),
          ],
        ),
        title: Text(
          item.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        // tileColor: Theme.of(context).colorScheme.surfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: () {
          Navigator.pushNamed(context, TODO_PAGE, arguments: item.id);
        },
      );
    }

    return ListTile(
      leading: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.circle, color: Colors.white, size: 20),
          Icon(Icons.circle, color: item.color, size: 18),
        ],
      ),
      title: Text(
        item.name,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      tileColor: Theme.of(context).colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onTap: () {
        Navigator.pushNamed(context, TODO_PAGE, arguments: item.id);
      },
    );
  }
}
