import 'package:flutter/material.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/router/router_generator.dart';
import 'package:todo_flutter/router/router_name.dart';

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
    const appColor = Color(0xFF0070F3);

    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: appColor,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: appColor,
          brightness: Brightness.dark,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.grey[600]),
          fillColor: Colors.grey[800],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            backgroundColor: MaterialStateProperty.resolveWith(
              (states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.grey[700];
                } else {
                  return appColor;
                }
              },
            ),
            foregroundColor: MaterialStateProperty.all(
              Colors.white,
            ),
          ),
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      initialRoute: isAuth ? HOME_PAGE : LOGIN_PAGE,
      onGenerateRoute: RouterGenerator.onGenerateRoute,
    );
  }
}
