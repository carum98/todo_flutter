import 'package:flutter/material.dart';
import 'package:todo_flutter/widgets/form_scaffold.dart';

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
    return Material(
      color: Theme.of(context).colorScheme.surfaceVariant,
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
            child: FormScaffold(
              buttonTitle: title,
              values: values,
              onSend: onSend,
              children: children,
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
