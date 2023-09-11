import 'package:flutter/material.dart';
import 'package:todo_flutter/core/platform.dart';

class ListCounter extends StatelessWidget {
  final int count;

  const ListCounter({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 25,
      decoration: const BoxDecoration(
        color: Color.fromARGB(51, 0, 0, 0),
        shape: BoxShape.circle,
      ),
      padding: Platform.isWindows ? const EdgeInsets.only(bottom: 2) : null,
      child: Center(
        child: Text(
          count.toString(),
          style: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}
