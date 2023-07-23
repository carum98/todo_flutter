import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/models/list_model.dart';
import 'package:todo_flutter/widgets/form_scaffold.dart';

class ListsForm extends StatelessWidget {
  final ListModel? item;
  const ListsForm({this.item});

  @override
  Widget build(BuildContext context) {
    final repo = DI.of(context).listRepository;

    final name = ValueNotifier(item?.name ?? '');
    final color = ValueNotifier(item?.color ?? const Color(0xfff44336));

    Future<void> send() async {
      final nameValue = name.value.trim();
      final colorValue = '#${color.value.hex}';

      final data = (name: nameValue, color: colorValue);

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
        values: [name],
        onSend: send,
        children: [
          TextFormField(
            initialValue: name.value,
            decoration: const InputDecoration(hintText: 'Name'),
            autofocus: true,
            onChanged: (value) => name.value = value,
          ),
          ColorPicker(
            color: color.value,
            onColorChanged: (Color value) => color.value = value,
            enableShadesSelection: false,
            padding: EdgeInsets.zero,
            pickersEnabled: const <ColorPickerType, bool>{
              ColorPickerType.accent: false,
            },
          ),
        ],
      ),
    );
  }
}
