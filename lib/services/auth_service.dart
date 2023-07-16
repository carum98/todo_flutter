import 'package:todo_flutter/services/api_service.dart';

class AuthService {
  final ApiService _api;

  AuthService({required ApiService api}) : _api = api;

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await _api.post('/login', {
      'user_name': username,
      'password': password,
    });

    return response.data;
  }

  Future<Map<String, dynamic>> register(
    String name,
    String username,
    String password,
  ) async {
    final response = await _api.post('/register', {
      'name': name,
      'user_name': username,
      'password': password,
    });

    return response.data;
  }
}
