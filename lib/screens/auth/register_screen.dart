import 'package:flutter/material.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/router/router_name.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = DI.of(context).authRepository;

    final formKey = GlobalKey<FormState>();

    String name = '';
    String username = '';
    String password = '';

    Future<void> send() async {
      await repo.register(name, username, password);

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          HOME_PAGE,
          (route) => false,
        );
      }
    }

    return Material(
      child: SafeArea(
        child: Column(
          children: [
            const Text('Register Page'),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    onSaved: (value) => name = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Username'),
                    onSaved: (value) => username = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) => password = value!,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        send();
                      }
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, LOGIN_PAGE);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
