import 'package:flutter/material.dart';
import 'package:todo_flutter/screens/screens.dart';

import 'router_name.dart';

class RouterGenerator {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HOME_PAGE:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case LOGIN_PAGE:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case REGISTER_PAGE:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundScreen());
    }
  }
}