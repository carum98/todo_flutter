import 'package:flutter/material.dart';
import 'package:todo_flutter/models/list_model.dart';
import 'package:todo_flutter/repository/list_respository.dart';
import 'package:todo_flutter/router/router_name.dart';

import 'form_lists.dart';
import 'actions_lists.dart';

class ListLists extends StatefulWidget {
  final ListRepository repo;
  final List<ListModel> items;

  const ListLists({
    super.key,
    required this.repo,
    required this.items,
  });

  @override
  State<ListLists> createState() => _ListListsState();
}

class _ListListsState extends State<ListLists> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: widget.items.length,
      itemBuilder: (_, index) {
        final item = widget.items[index];

        return ActionsLists(
          keyAction: ValueKey<int>(item.id),
          onDelete: () async {
            await widget.repo.delete(item.id);

            widget.items.removeAt(index);
          },
          onEdit: () async {
            final data = await showDialog(
              context: context,
              builder: (_) => Dialog(
                child: FormList(item: item),
              ),
            );

            widget.items.removeAt(index);
            widget.items.insert(index, data as ListModel);

            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TileList(list: item),
          ),
        );
      },
    );
  }
}

class TileList extends StatelessWidget {
  final ListModel list;
  const TileList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.circle, color: Colors.white, size: 20),
          Icon(Icons.circle, color: list.color, size: 18),
        ],
      ),
      minLeadingWidth: 0,
      title: Text(
        list.name,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      tileColor: Theme.of(context).colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          TODO_PAGE,
          arguments: list.id,
        );
      },
    );
  }
}
