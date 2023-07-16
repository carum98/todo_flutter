import 'package:flutter/material.dart';
import 'package:todo_flutter/router/router_generator.dart';
import 'package:todo_flutter/router/router_name.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final bool isAuth = false;

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      initialRoute: isAuth ? HOME_PAGE : LOGIN_PAGE,
      onGenerateRoute: RouterGenerator.onGenerateRoute,
    );
  }
}
