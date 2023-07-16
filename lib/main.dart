import 'package:flutter/material.dart';
import 'package:todo_flutter/router/router_generator.dart';
import 'package:todo_flutter/router/router_name.dart';
import 'package:todo_flutter/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isAuth = await StorageService().containsKey('token');
  runApp(MyApp(isAuth: isAuth));
}

class MyApp extends StatelessWidget {
  final bool isAuth;

  const MyApp({super.key, required this.isAuth});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: isAuth ? HOME_PAGE : LOGIN_PAGE,
      onGenerateRoute: RouterGenerator.onGenerateRoute,
    );
  }
}
