import 'package:http/http.dart' as http;

class AuthService {
  Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.10.179:8080/login'),
      body: {
        'user_name': email,
        'password': password,
      },
    );

    return response;
  }

  Future<http.Response> register(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.10.179:8080/register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    return response;
  }
}
