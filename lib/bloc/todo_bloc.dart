import 'dart:async';

import 'package:todo_flutter/bloc/lists_bloc.dart';
import 'package:todo_flutter/repository/todo_repository.dart';

import 'todo_bloc_event.dart';
import 'todo_bloc_state.dart';

export 'todo_bloc_event.dart';
export 'todo_bloc_state.dart';

class TodoBloc {
  final TodoRepository _repository;
  final StreamController<TodoBlocState> _controller;
  final ListBloc _listBloc;
  final int _listId;

  TodoBlocState state = TodoBlocLoading();

  TodoBloc(
      {required TodoRepository repository,
      required int listId,
      required ListBloc listBloc})
      : _repository = repository,
        _listBloc = listBloc,
        _listId = listId,
        _controller = StreamController<TodoBlocState>.broadcast() {
    _controller.stream.listen((value) => state = value);
  }

  Stream<TodoBlocState> get stream => _controller.stream;

  onEvent(TodoBlocEvent event) async {
    if (event is TodoBlocGetAll) {
      await _getAll();
    } else if (event is TodoBlocAdd) {
      await _add(event);
    } else if (event is TodoBlocUpdate) {
      await _update(event);
    } else if (event is TodoBlocDelete) {
      await _delete(event);
    } else if (event is TodoBlocToggle) {
      await _toggle(event);
    }
  }

  Future<void> _getAll() async {
    _controller.add(TodoBlocLoading());

    final items = await _repository.getTodos(_listId);

    _controller.add(TodoBlocLoaded(items));
  }

  Future<void> _add(TodoBlocAdd event) async {
    if (state is TodoBlocLoaded) {
      final items = (state as TodoBlocLoaded).items;

      items.insert(0, event.item);

      _controller.add(TodoBlocLoaded(items));

      _listBloc.onEvent(ListBlocIncressCount(_listId));
    }
  }

  Future<void> _update(TodoBlocUpdate event) async {
    if (state is TodoBlocLoaded) {
      final items = (state as TodoBlocLoaded).items;

      final index = items.indexWhere((x) => x.id == event.item.id);

      items[index] = event.item;

      _controller.add(TodoBlocLoaded(items));
    }
  }

  Future<void> _delete(TodoBlocDelete event) async {
    if (state is TodoBlocLoaded) {
      final items = (state as TodoBlocLoaded).items;

      final index = items.indexWhere((x) => x.id == event.item.id);

      items.removeAt(index);

      _controller.add(TodoBlocLoaded(items));

      if (event.item.completed) {
        _listBloc.onEvent(ListBlocDecressCount(_listId));
      }
    }
  }

  Future<void> _toggle(TodoBlocToggle event) async {
    final todo = await _repository.toggle(event.item.id);

    if (todo.completed) {
      _listBloc.onEvent(ListBlocDecressCount(_listId));
    } else {
      _listBloc.onEvent(ListBlocIncressCount(_listId));
    }
  }

  void dispose() {
    _controller.close();
  }
}
