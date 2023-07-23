import 'package:todo_flutter/core/repository_interfaz.dart';
import 'package:todo_flutter/models/list_model.dart';
import 'package:todo_flutter/services/list_service.dart';

class ListRepository
    implements Repository<ListModel, ({String name, String color})> {
  final ListService _api;

  ListRepository({required ListService api}) : _api = api;

  @override
  Future<List<ListModel>> getAll() async {
    final response = await _api.getAll();

    return List<ListModel>.from(
      response['data'].map((x) => ListModel.fromJson(x)),
    ).toList();
  }

  @override
  Future<ListModel> get(int id) async {
    final response = await _api.get(id);

    return ListModel.fromJson(response);
  }

  @override
  Future<ListModel> add(({String color, String name}) data) async {
    final response = await _api.create(
      data.name,
      data.color,
    );

    return ListModel.fromJson(response);
  }

  @override
  Future<ListModel> update(int id, ({String color, String name}) data) async {
    final response = await _api.update(
      id,
      data.name,
      data.color,
    );

    return ListModel.fromJson(response);
  }

  @override
  Future<void> delete(int id) async {
    await _api.delete(id);
  }

  @override
  Future<void> move(int id, int position) {
    throw UnimplementedError();
  }
}
