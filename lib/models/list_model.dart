import 'package:flutter/widgets.dart';
import 'package:todo_flutter/core/identifiable_interfaz.dart';

class ListModel implements Identifiable {
  @override
  final int id;

  final String name;
  final Color color;

  ListModel({
    required this.id,
    required this.name,
    required this.color,
  });

  factory ListModel.fromJson(Map<String, dynamic> json) {
    return ListModel(
      id: json['id'],
      name: json['name'],
      color: Color(
        int.parse((json['color'] as String).replaceAll('#', '0xFF')),
      ),
    );
  }
}
