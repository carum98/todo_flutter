import 'package:flutter/widgets.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/router/router_name.dart';
import 'package:todo_flutter/widgets/auth_scaffold.dart';
import 'package:todo_flutter/widgets/platform_form_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = DI.of(context).authRepository;

    final name = ValueNotifier('');
    final username = ValueNotifier('');
    final password = ValueNotifier('');

    Future<void> send() async {
      await repo.register(name.value, username.value, password.value);

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          HOME_PAGE,
          (route) => false,
        );
      }
    }

    return AuthScaffold(
      title: 'Register',
      values: [name, username, password],
      onSend: send,
      redirect: (label: 'Login', routeName: LOGIN_PAGE),
      children: [
        PlatformFormField(
          hintText: 'Name',
          onChanged: (value) => name.value = value,
        ),
        PlatformFormField(
          hintText: 'Username',
          onChanged: (value) => username.value = value,
        ),
        PlatformFormField(
          hintText: 'Password',
          obscureText: true,
          onChanged: (value) => password.value = value,
        ),
      ],
    );
  }
}
