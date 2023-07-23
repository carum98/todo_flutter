import 'package:flutter/material.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/models/todo_model.dart';
import 'package:todo_flutter/widgets/form_scaffold.dart';

class TodosForm extends StatelessWidget {
  final TodoModel? item;
  final int listId;

  const TodosForm({super.key, this.item, required this.listId});

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
