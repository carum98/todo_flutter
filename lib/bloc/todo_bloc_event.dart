import 'package:todo_flutter/models/todo_model.dart';

sealed class TodoBlocEvent {}

class TodoBlocGetAll extends TodoBlocEvent {
  TodoBlocGetAll();
}

class TodoBlocAdd extends TodoBlocEvent {
  final TodoModel item;

  TodoBlocAdd(this.item);
}

class TodoBlocUpdate extends TodoBlocEvent {
  final TodoModel item;

  TodoBlocUpdate(this.item);
}

class TodoBlocDelete extends TodoBlocEvent {
  final TodoModel item;

  TodoBlocDelete(this.item);
}

class TodoBlocToggle extends TodoBlocEvent {
  final TodoModel item;

  TodoBlocToggle(this.item);
}
