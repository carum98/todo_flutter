import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/models/list_model.dart';
import 'package:todo_flutter/screens/lists/form_lists.dart';
import 'package:todo_flutter/screens/lists/list_lists.dart';
import 'package:todo_flutter/services/api_service.dart'
    show UnauthorizedException;

class ListsScreen extends StatefulWidget {
  const ListsScreen({super.key});

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  late final StreamSubscription _logger;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logger = DI.of(context).onApiError.listen((event) {
        if (event.runtimeType == UnauthorizedException) {
          logout();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(event.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    _logger.cancel();
  }

  void logout() {
    DI.of(context).authRepository.logout(context);
  }

  @override
  Widget build(BuildContext context) {
    final repo = DI.of(context).listRepository;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo App'),
        leading: Container(),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder(
        future: repo.get(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return ListLists(
              repo: repo,
              items: snapshot.data as List<ListModel>,
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final item = await showDialog(
            context: context,
            builder: (_) => const Dialog(
              child: FormList(),
            ),
          );

          if (item != null) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
