import 'package:flutter/material.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/router/router_name.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = DI.of(context).listRepository;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo App'),
        leading: Container(),
        actions: [
          IconButton(
            onPressed: () {
              DI.of(context).authRepository.logout();

              Navigator.pushNamedAndRemoveUntil(
                context,
                LOGIN_PAGE,
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder(
        future: repo.get(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                final item = snapshot.data![index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.circle, color: item.color),
                    title: Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    tileColor: Theme.of(context).colorScheme.surfaceVariant,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        TODO_PAGE,
                        arguments: item.id,
                      );
                    },
                  ),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
