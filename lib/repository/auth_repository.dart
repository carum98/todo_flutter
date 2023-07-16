import 'dart:convert';

import 'package:todo_flutter/models/auth_model.dart';
import 'package:todo_flutter/services/auth_service.dart';
import 'package:todo_flutter/services/storage_service.dart';

class AuthRepository {
  static const storageName = 'auth';

  final AuthService _api;
  final StorageService _storage;

  AuthRepository({required StorageService storage, required AuthService api})
      : _storage = storage,
        _api = api;

  Future<Auth?> get() async {
    final map = await _storage.read(storageName);

    if (map == null) {
      return null;
    }

    return Auth.fromJson(jsonDecode(map));
  }

  Future<bool> login(String username, String password) async {
    final response = await _api.login(username, password);

    if (response.statusCode != 200) {
      return false;
    }

    await _save(jsonDecode(response.body));

    return true;
  }

  Future<bool> register(String name, String username, String password) async {
    final response = await _api.register(name, username, password);

    if (response.statusCode != 200) {
      return false;
    }

    await _save(jsonDecode(response.body));

    return true;
  }

  Future<void> logout() async {
    await _delete();
  }

  Future<void> _save(Map<String, dynamic> map) {
    return _storage.write(storageName, Auth.fromJson(map).toJson().toString());
  }

  Future<void> _delete() {
    return _storage.delete(storageName);
  }
}
