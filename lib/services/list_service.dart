import 'api_service.dart';

class ListService {
  final ApiService _api;

  ListService({required ApiService api}) : _api = api;

  Future<Map<String, dynamic>> getList() async {
    final response = await _api.get('/lists');

    return response.data;
  }

  Future<Map<String, dynamic>> create(String name, String color) async {
    final response = await _api.post('/lists', {
      'name': name,
      'color': color,
    });

    return response.data;
  }

  Future<void> delete(int id) async {
    await _api.delete('/lists/$id');
  }

  Future<Map<String, dynamic>> update(int id, String name, String color) async {
    final response = await _api.put('/lists/$id', {
      'name': name,
      'color': color,
    });

    return response.data;
  }
}
