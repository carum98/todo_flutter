import 'package:todo_flutter/models/todo_model.dart';
import 'package:todo_flutter/services/todo_service.dart';

class TodoRepository {
  final TodoService _api;

  TodoRepository({required TodoService api}) : _api = api;

  Future<List<TodoModel>> get(int todoId) async {
    final response = await _api.getTodo(todoId);

    return List<TodoModel>.from(
      response['data'].map((x) => TodoModel.fromJson(x)),
    ).toList();
  }

  Future<TodoModel> toggle(int id) async {
    final response = await _api.toggle(id);

    return TodoModel.fromJson(response);
  }
}
