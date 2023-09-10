// Event
import 'package:todo_flutter/models/list_model.dart';

sealed class ListBlocEvent {}

class ListBlocGetAll extends ListBlocEvent {}

class ListBlocAdd extends ListBlocEvent {
  final ListModel item;

  ListBlocAdd(this.item);
}

class ListBlocUpdate extends ListBlocEvent {
  final ListModel item;

  ListBlocUpdate(this.item);
}

class ListBlocDelete extends ListBlocEvent {
  final ListModel item;

  ListBlocDelete(this.item);
}

class ListBlocIncressCount extends ListBlocEvent {
  final int listId;

  ListBlocIncressCount(this.listId);
}

class ListBlocDecressCount extends ListBlocEvent {
  final int listId;

  ListBlocDecressCount(this.listId);
}
