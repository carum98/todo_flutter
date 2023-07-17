import 'package:todo_flutter/models/list_model.dart';

import 'api_service.dart';

class ListService {
  final ApiService _api;

  ListService({required ApiService api}) : _api = api;

  Future<List<ListModel>> getList() async {
    final response = await _api.get('/lists');

    return List<ListModel>.from(
      response.data['data'].map((x) => ListModel.fromJson(x)),
    ).toList();
  }
}
