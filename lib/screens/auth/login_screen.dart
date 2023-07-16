import 'package:flutter/material.dart';
import 'package:todo_flutter/router/router_name.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        print('username: $username');
                        print('password: $password');

                        Navigator.pushNamed(context, HOME_PAGE);
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
