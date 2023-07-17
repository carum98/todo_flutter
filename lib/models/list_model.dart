import 'package:flutter/widgets.dart';

class ListModel {
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
