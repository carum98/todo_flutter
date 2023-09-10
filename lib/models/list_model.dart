import 'package:flutter/widgets.dart';
import 'package:todo_flutter/core/identifiable_interfaz.dart';

class ListModel implements Identifiable {
  @override
  final int id;

  final String name;
  final Color color;
  final int count;

  ListModel({
    required this.id,
    required this.name,
    required this.color,
    required this.count,
  });

  factory ListModel.fromJson(Map<String, dynamic> json) {
    return ListModel(
      id: json['id'],
      name: json['name'],
      color: Color(
        int.parse((json['color'] as String).replaceAll('#', '0xFF')),
      ),
      count: json['count']['pending'],
    );
  }

  ListModel copyWith({
    int? id,
    String? name,
    Color? color,
    int? count,
  }) {
    return ListModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      count: count ?? this.count,
    );
  }
}
