import 'dart:convert';

import 'package:todo_flutter/services/auth_service.dart';
import 'package:todo_flutter/services/storage_service.dart';

class AuthRepository {
  final AuthService _api = AuthService();
  final StorageService _storage = StorageService();

  Future<String?> login(String username, String password) async {
    final response = await _api.login(username, password);

    if (response.statusCode != 200) {
      return null;
    }

    final token = jsonDecode(response.body)['token'];

    await _storage.write('token', token);

    return token;
  }
}
