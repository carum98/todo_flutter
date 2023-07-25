import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/core/platform.dart';
import 'package:todo_flutter/screens/screens.dart';

import 'router_name.dart';

class RouterGenerator {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HOME_PAGE:
        return pageRouter(
          Platform.isWindows || Platform.isMacOS
              ? const HomeScreen()
              : const ListsScreen(),
        );
      case LOGIN_PAGE:
        return pageRouter(
          Platform.isMacOS
              ? const LoginScreen()
              : const Material(child: LoginScreen()),
        );
      case REGISTER_PAGE:
        return pageRouter(
          Platform.isMacOS
              ? const RegisterScreen()
              : const Material(child: RegisterScreen()),
        );
      case TODO_PAGE:
        final listId = settings.arguments as int;
        return pageRouter(TodoScreen(listId: listId));
      default:
        return pageRouter(const NotFoundScreen());
    }
  }
}

pageRouter(Widget page) {
  if (Platform.isWindows) {
    return FluentPageRoute(builder: (_) => page);
  }

  if (Platform.isMacOS || Platform.isIOS) {
    return CupertinoPageRoute(builder: (_) => page);
  }

  return MaterialPageRoute(builder: (_) => page);
}
