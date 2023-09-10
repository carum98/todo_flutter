import 'package:todo_flutter/models/todo_model.dart';

sealed class TodoBlocState {}

class TodoBlocLoading extends TodoBlocState {}

class TodoBlocLoaded extends TodoBlocState {
  final List<TodoModel> items;

  TodoBlocLoaded(this.items);
}
