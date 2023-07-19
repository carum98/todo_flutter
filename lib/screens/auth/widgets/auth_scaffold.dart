import 'package:flutter/material.dart';

class AuthScaffold extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final List<ValueNotifier<String>> values;
  final Function() onSend;
  final ({String label, String routeName}) redirect;

  const AuthScaffold({
    super.key,
    required this.title,
    required this.children,
    required this.values,
    required this.onSend,
    required this.redirect,
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

    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 300,
            child: Form(
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
                      builder: (_, value, __) => ElevatedButton(
                        onPressed: value ? send : null,
                        child: Text(title),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, redirect.routeName),
            child: Text(redirect.label),
          ),
        ],
      ),
    );
  }
}
