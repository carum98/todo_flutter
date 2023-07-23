import 'package:flutter/material.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/router/router_generator.dart';
import 'package:todo_flutter/router/router_name.dart';

import 'core/theme.dart';
import 'services/storage_service.dart';
import 'services/token_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isAuth = await StorageService().containsKey(TokenService.storageName);

  runApp(DI(child: MyApp(isAuth: isAuth)));
}

class MyApp extends StatelessWidget {
  final bool isAuth;

  const MyApp({super.key, required this.isAuth});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeController.light,
      darkTheme: ThemeController.dark,
      debugShowCheckedModeBanner: false,
      initialRoute: isAuth ? HOME_PAGE : LOGIN_PAGE,
      onGenerateRoute: RouterGenerator.onGenerateRoute,
    );
  }
}
