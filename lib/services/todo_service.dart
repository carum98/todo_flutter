import 'api_service.dart';

class TodoService {
  final ApiService _api;

  TodoService({required ApiService api}) : _api = api;

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
