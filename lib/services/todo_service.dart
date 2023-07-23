import 'api_service.dart';

class TodoService {
  final ApiService _api;

  TodoService({required ApiService api}) : _api = api;

  Future<Map<String, dynamic>> get(int id) async {
    final response = await _api.get('/todos/$id');

    return response.data;
  }

  Future<Map<String, dynamic>> getAll() async {
    final response = await _api.get('/todos');

    return response.data;
  }

  Future<Map<String, dynamic>> create(int listId, String title) async {
    final response = await _api.post('/lists/$listId/todos', {
      'title': title,
    });

    return response.data;
  }

  Future<void> delete(int id) async {
    await _api.delete('/todos/$id');
  }

  Future<Map<String, dynamic>> update(int id, String title) async {
    final response = await _api.put('/todos/$id', {
      'title': title,
    });

    return response.data;
  }

  Future<Map<String, dynamic>> getTodo(int listId) async {
    final response = await _api.get('/lists/$listId/todos');

    return response.data;
  }

  Future<Map<String, dynamic>> toggle(id) async {
    final response = await _api.post('/todos/$id/toggle', null);

    return response.data;
  }

  Future<Map<String, dynamic>> move(int id, int position) async {
    final response = await _api.post('/todos/$id/move', {
      'position': position.toString(),
    });

    return response.data;
  }
}
