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
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        final isAuth = await repo.login(username, password);

                        if (isAuth && context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            HOME_PAGE,
                            (route) => false,
                          );
                        }
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
