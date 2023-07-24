import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/core/platform.dart';
import 'package:todo_flutter/models/list_model.dart';
import 'package:todo_flutter/widgets/form_scaffold.dart';
import 'package:todo_flutter/widgets/platform_form_field.dart';

class ListsForm extends StatelessWidget {
  final ListModel? item;
  const ListsForm({super.key, this.item});

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
          PlatformFormField(
            initialValue: name.value,
            hintText: 'Name',
            autofocus: true,
            onChanged: (value) => name.value = value,
          ),
          ColorPicker(
            color: color.value,
            onColorChanged: (Color value) => color.value = value,
            enableShadesSelection: false,
            padding: EdgeInsets.zero,
            width: Platform.isMacOS ? 20 : 40,
            height: Platform.isMacOS ? 20 : 40,
            pickersEnabled: const <ColorPickerType, bool>{
              ColorPickerType.accent: false,
            },
          ),
        ],
      ),
    );
  }
}
