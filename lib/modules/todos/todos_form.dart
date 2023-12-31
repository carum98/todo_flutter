import 'package:flutter/widgets.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/models/todo_model.dart';
import 'package:todo_flutter/widgets/form_scaffold.dart';
import 'package:todo_flutter/widgets/platform_form_field.dart';

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

    return FormScaffold(
      buttonTitle: item != null ? 'Update' : 'Create',
      values: [title],
      onSend: send,
      children: [
        PlatformFormField(
          initialValue: title.value,
          hintText: 'Title',
          autofocus: true,
          onChanged: (value) => title.value = value,
        ),
      ],
    );
  }
}
