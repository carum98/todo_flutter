import 'package:flutter/material.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/models/todo_model.dart';
import 'package:todo_flutter/widgets/form_scaffold.dart';
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
              formBuilder: (item) => _Form(
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
              child: _Form(listId: widget.listId),
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

class _Form extends StatelessWidget {
  final TodoModel? item;
  final int listId;
  const _Form({this.item, required this.listId});

  @override
  Widget build(BuildContext context) {
    final repo = DI.of(context).todoRepository;

    final title = ValueNotifier(item?.title ?? '');

    Future<void> send() async {
      final titleValue = title.value.trim();

      final data = (title: titleValue, listId: listId);

      final value = item != null
          ? await repo.update(item!.id, data)
          : await repo.add(data);

      if (context.mounted) {
        Navigator.pop(context, value);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: FormScaffold(
        buttonTitle: item != null ? 'Update' : 'Create',
        values: [title],
        onSend: send,
        children: [
          TextFormField(
            initialValue: title.value,
            decoration: const InputDecoration(hintText: 'Title'),
            autofocus: true,
            onChanged: (value) => title.value = value,
          ),
        ],
      ),
    );
  }
}
