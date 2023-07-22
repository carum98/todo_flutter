import 'package:flutter/material.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/models/todo_model.dart';
import 'package:todo_flutter/repository/todo_repository.dart';

class TodoScreen extends StatelessWidget {
  final int listId;

  const TodoScreen({super.key, required this.listId});

  @override
  Widget build(BuildContext context) {
    final repo = DI.of(context).todoRepository;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDos'),
      ),
      body: FutureBuilder(
        future: repo.get(listId),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return _List(
              repo: repo,
              items: snapshot.data as List<TodoModel>,
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _List extends StatefulWidget {
  final TodoRepository repo;
  final List<TodoModel> items;

  const _List({
    required this.repo,
    required this.items,
  });

  @override
  State<_List> createState() => _ListState();
}

class _ListState extends State<_List> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: widget.items.length,
      itemBuilder: (_, index) {
        final item = widget.items[index];

        return ToDoTile(
          key: ValueKey(item.id),
          item: item,
          onTap: () => widget.repo.toggle(item.id),
        );
      },
      onReorder: (int oldIndex, int newIndex) {
        final index = newIndex > oldIndex ? newIndex - 1 : newIndex;

        final item = widget.items[oldIndex];

        setState(() {
          widget.items.removeAt(oldIndex);
          widget.items.insert(index, item);
        });

        widget.repo.move(item.id, newIndex).onError((error, stackTrace) {
          setState(() {
            widget.items.removeAt(index);
            widget.items.insert(oldIndex, item);
          });
        });
      },
    );
  }
}

class ToDoTile extends StatefulWidget {
  final TodoModel item;
  final VoidCallback? onTap;

  const ToDoTile({super.key, required this.item, this.onTap});

  @override
  State<ToDoTile> createState() => _ToDoTileState();
}

class _ToDoTileState extends State<ToDoTile> {
  late bool isComplete;

  @override
  void initState() {
    super.initState();

    isComplete = widget.item.completed;
  }

  @override
  Widget build(BuildContext context) {
    final color = isComplete ? Colors.grey[700] : Colors.white;

    return ListTile(
      leading: Icon(
        isComplete
            ? Icons.radio_button_checked_outlined
            : Icons.radio_button_unchecked_outlined,
        color: color,
      ),
      title: Text(
        widget.item.title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(color: color),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () {
        setState(() {
          isComplete = !isComplete;
        });

        widget.onTap?.call();
      },
    );
  }
}
