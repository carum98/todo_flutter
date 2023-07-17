import 'package:flutter/material.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/models/todo_model.dart';

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
            return ListView.separated(
              padding: const EdgeInsets.all(15),
              separatorBuilder: (_, __) => const Divider(),
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                final item = snapshot.data![index];

                return ToDoTile(item: item, onTap: () => repo.toggle(item.id));
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
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
