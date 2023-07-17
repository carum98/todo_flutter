import 'package:todo_flutter/models/list_model.dart';
import 'package:todo_flutter/services/list_service.dart';

class ListRepository {
  final ListService _api;

  ListRepository({required ListService api}) : _api = api;

  Future<List<ListModel>> get() async {
    final response = await _api.getList();

    return List<ListModel>.from(
      response['data'].map((x) => ListModel.fromJson(x)),
    ).toList();
  }
}
