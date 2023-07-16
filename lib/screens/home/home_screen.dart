import 'package:flutter/material.dart';
import 'package:todo_flutter/router/router_name.dart';
import 'package:todo_flutter/services/storage_service.dart';

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
            StorageService().delete('token');

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
