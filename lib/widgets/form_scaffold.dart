import 'package:flutter/material.dart';
import 'package:todo_flutter/widgets/platform_button.dart';

class FormScaffold extends StatelessWidget {
  final String buttonTitle;
  final List<Widget> children;
  final List<ValueNotifier<String>> values;
  final Function() onSend;

  const FormScaffold({
    super.key,
    required this.buttonTitle,
    required this.children,
    required this.values,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final isEnabled = ValueNotifier(false);

    void validate() {
      isEnabled.value = values.every((element) => element.value.isNotEmpty);
    }

    for (var element in values) {
      element.addListener(validate);
    }

    void send() {
      if (!formKey.currentState!.validate()) {
        return;
      }

      onSend();
    }

    return Form(
      key: formKey,
      child: Wrap(
        runSpacing: 20,
        children: [
          ...children,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ValueListenableBuilder(
              valueListenable: isEnabled,
              builder: (_, value, __) => PlatformButton(
                onPressed: value ? send : null,
                buttonTitle: buttonTitle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
