import 'dart:async';

import 'package:todo_flutter/repository/list_respository.dart';

import 'lists_bloc_event.dart';
import 'lists_bloc_state.dart';

export 'lists_bloc_event.dart';
export 'lists_bloc_state.dart';

class ListBloc {
  final ListRepository _repository;
  final StreamController<ListBlocState> _controller;
  ListBlocState state = ListBlocLoading();

  ListBloc({required ListRepository repository})
      : _repository = repository,
        _controller = StreamController<ListBlocState>.broadcast() {
    _controller.stream.listen((value) => state = value);
  }

  Stream<ListBlocState> get stream => _controller.stream;

  onEvent(ListBlocEvent event) async {
    if (event is ListBlocGetAll) {
      await _getAll();
    } else if (event is ListBlocAdd) {
      await _add(event);
    } else if (event is ListBlocUpdate) {
      await _update(event);
    } else if (event is ListBlocDelete) {
      await _delete(event);
    } else if (event is ListBlocIncressCount) {
      await _setCount(event.listId, 1);
    } else if (event is ListBlocDecressCount) {
      await _setCount(event.listId, -1);
    }
  }

  Future<void> _getAll() async {
    _controller.add(ListBlocLoading());

    final items = await _repository.getAll();

    _controller.add(ListBlocLoaded(items));
  }

  Future<void> _add(ListBlocAdd event) async {
    if (state is ListBlocLoaded) {
      final items = (state as ListBlocLoaded).items;

      items.insert(0, event.item);

      _controller.add(ListBlocLoaded(items));
    }
  }

  Future<void> _update(ListBlocUpdate event) async {
    if (state is ListBlocLoaded) {
      final items = (state as ListBlocLoaded).items;

      final index = items.indexWhere((x) => x.id == event.item.id);

      items[index] = event.item;

      _controller.add(ListBlocLoaded(items));
    }
  }

  Future<void> _delete(ListBlocDelete event) async {
    if (state is ListBlocLoaded) {
      final items = (state as ListBlocLoaded).items;

      final index = items.indexWhere((x) => x.id == event.item.id);

      items.removeAt(index);

      _controller.add(ListBlocLoaded(items));
    }
  }

  Future<void> _setCount(int listId, int value) async {
    if (state is ListBlocLoaded) {
      final items = (state as ListBlocLoaded).items;

      final index = items.indexWhere((x) => x.id == listId);

      items[index] = items[index].copyWith(count: items[index].count + value);

      _controller.add(ListBlocLoaded(items));
    }
  }

  void dispose() {
    _controller.close();
  }
}
