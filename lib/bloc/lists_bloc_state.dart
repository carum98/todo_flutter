import 'package:todo_flutter/models/list_model.dart';

sealed class ListBlocState {}

class ListBlocLoading extends ListBlocState {}

class ListBlocLoaded extends ListBlocState {
  final List<ListModel> items;

  ListBlocLoaded(this.items);
}
