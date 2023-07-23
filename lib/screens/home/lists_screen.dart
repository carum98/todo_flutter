import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/features/lists/lists_form.dart';
import 'package:todo_flutter/features/lists/lists_tile.dart';
import 'package:todo_flutter/models/list_model.dart';
import 'package:todo_flutter/services/api_service.dart'
    show UnauthorizedException;
import 'package:todo_flutter/widgets/list_scaffold.dart';

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
        future: repo.getAll(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return ListScaffold(
              items: snapshot.data as List<ListModel>,
              repository: repo,
              formBuilder: (item) => ListsForm(item: item),
              indentifierBuilder: (item) => item.id,
              itemBuilder: (item, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListsTile(item: item),
              ),
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
              child: ListsForm(),
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
