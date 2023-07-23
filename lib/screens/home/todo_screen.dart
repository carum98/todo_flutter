import 'package:flutter/material.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/features/todos/todos_form.dart';
import 'package:todo_flutter/features/todos/todos_tile.dart';
import 'package:todo_flutter/models/todo_model.dart';
import 'package:todo_flutter/widgets/list_scaffold.dart';

class TodoScreen extends StatefulWidget {
  final int listId;
  const TodoScreen({super.key, required this.listId});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    final repo = DI.of(context).todoRepository;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDos'),
      ),
      body: FutureBuilder(
        future: repo.getTodos(widget.listId),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return ListScaffold(
              items: snapshot.data as List<TodoModel>,
              repository: repo,
              reorderable: true,
              formBuilder: (item) => TodosForm(
                item: item,
                listId: widget.listId,
              ),
              indentifierBuilder: (item) => item.id,
              itemBuilder: (item, index) => ToDoTile(
                item: item,
                onTap: () => repo.toggle(item.id),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final item = await showDialog(
            context: context,
            builder: (_) => Dialog(
              child: TodosForm(listId: widget.listId),
            ),
          );

          if (item != null) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
