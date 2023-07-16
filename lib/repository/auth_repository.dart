import 'dart:convert';

import 'package:todo_flutter/services/auth_service.dart';

class AuthRepository {
  final AuthService _api = AuthService();

  Future<String?> login(String username, String password) async {
    final response = await _api.login(username, password);

    if (response.statusCode != 200) {
      return null;
    }

    final token = jsonDecode(response.body)['token'];

    return token;
  }
}
