import 'api_service.dart';

class ListService {
  final ApiService _api;

  ListService({required ApiService api}) : _api = api;

  Future<Map<String, dynamic>> getList() async {
    final response = await _api.get('/lists');

    return response.data;
  }
}
