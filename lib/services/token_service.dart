import 'dart:convert';

import 'package:todo_flutter/models/auth_model.dart';

import 'storage_service.dart';

class TokenService {
  static String storageName = 'auth';

  final StorageService _storage;

  TokenService({required StorageService storage}) : _storage = storage;

  Future<Auth?> get() async {
    final map = await _storage.read(storageName);

    if (map == null) {
      return null;
    }

    return Auth.fromJson(jsonDecode(map));
  }

  Future<void> save(Map<String, dynamic> map) {
    return _storage.write(storageName, Auth.fromJson(map).toJson().toString());
  }

  Future<void> delete() {
    return _storage.delete(storageName);
  }
}
