import 'package:todo_flutter/services/auth_service.dart';
import 'package:todo_flutter/services/token_service.dart';

class AuthRepository {
  final AuthService _api;
  final TokenService _tokenService;

  AuthRepository({required TokenService tokenService, required AuthService api})
      : _tokenService = tokenService,
        _api = api;

  Future<void> login(String username, String password) async {
    final response = await _api.login(username, password);

    await _tokenService.save(response);
  }

  Future<void> register(String name, String username, String password) async {
    final response = await _api.register(name, username, password);

    await _tokenService.save(response);
  }

  Future<void> logout() async {
    await _tokenService.delete();
  }
}
