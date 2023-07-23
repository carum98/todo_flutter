import 'package:todo_flutter/core/repository_interfaz.dart';
import 'package:todo_flutter/models/todo_model.dart';
import 'package:todo_flutter/services/todo_service.dart';

class TodoRepository
    implements Repository<TodoModel, ({String title, int? listId})> {
  final TodoService _api;

  TodoRepository({required TodoService api}) : _api = api;

  Future<List<TodoModel>> getTodos(int todoId) async {
    final response = await _api.getTodo(todoId);

    return List<TodoModel>.from(
      response['data'].map((x) => TodoModel.fromJson(x)),
    ).toList();
  }

  Future<TodoModel> toggle(int id) async {
    final response = await _api.toggle(id);

    return TodoModel.fromJson(response);
  }

  @override
  Future<void> move(int id, int position) async {
    await _api.move(id, position);
  }

  @override
  Future<List<TodoModel>> getAll() async {
    final response = await _api.getAll();

    return List<TodoModel>.from(
      response['data'].map((x) => TodoModel.fromJson(x)),
    ).toList();
  }

  @override
  Future<TodoModel> add(({String title, int? listId}) data) async {
    final response = await _api.create(data.listId!, data.title);

    return TodoModel.fromJson(response);
  }

  @override
  Future<void> delete(int id) async {
    await _api.delete(id);
  }

  @override
  Future<TodoModel> get(int id) async {
    final response = await _api.get(id);

    return TodoModel.fromJson(response);
  }

  @override
  Future<TodoModel> update(int id, ({String title, int? listId}) data) async {
    final response = await _api.update(id, data.title);

    return TodoModel.fromJson(response);
  }
}
