import 'package:flutter/material.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/router/router_name.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        leading: Container(),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            DI.of(context).authRepository.logout();

            Navigator.pushNamedAndRemoveUntil(
              context,
              LOGIN_PAGE,
              (route) => false,
            );
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
