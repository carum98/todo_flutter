import 'package:flutter/widgets.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/router/router_name.dart';
import 'package:todo_flutter/widgets/auth_scaffold.dart';
import 'package:todo_flutter/widgets/platform_form_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = DI.of(context).authRepository;

    final username = ValueNotifier('');
    final password = ValueNotifier('');

    Future<void> send() async {
      await repo.login(username.value, password.value);

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          HOME_PAGE,
          (route) => false,
        );
      }
    }

    return AuthScaffold(
      title: 'Login',
      values: [username, password],
      onSend: send,
      redirect: (label: 'Register', routeName: REGISTER_PAGE),
      children: [
        PlatformFormField(
          hintText: 'Username',
          onChanged: (value) => username.value = value,
        ),
        PlatformFormField(
          hintText: 'Password',
          onChanged: (value) => password.value = value,
          obscureText: true,
        ),
      ],
    );
  }
}
