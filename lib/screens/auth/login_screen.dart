import 'package:flutter/material.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/router/router_name.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = DI.of(context).authRepository;

    final formKey = GlobalKey<FormState>();

    String username = '';
    String password = '';

    Future<void> send() async {
      try {
        await repo.login(username, password);

        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            HOME_PAGE,
            (route) => false,
          );
        }
      } catch (e) {
        print(e);
      }
    }

    return Material(
      child: SafeArea(
        child: Column(
          children: [
            const Text('Login Page'),
            Form(
              key: formKey,
              child: Column(
                children: [
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
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, REGISTER_PAGE);
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
