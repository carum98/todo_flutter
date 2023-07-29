import 'package:todo_flutter/core/identifiable_interfaz.dart';

class TodoModel implements Identifiable {
  @override
  final int id;

  final String title;
  final bool completed;

  TodoModel({
    required this.id,
    required this.title,
    required this.completed,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      completed: json['is_complete'],
    );
  }
}
