import 'package:http/http.dart' as http;

class AuthService {
  Future<http.Response> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.10.179:8080/login'),
      body: {
        'user_name': username,
        'password': password,
      },
    );

    return response;
  }

  Future<http.Response> register(
      String name, String username, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.10.179:8080/register'),
      body: {
        'name': name,
        'user_name': username,
        'password': password,
      },
    );

    return response;
  }
}
