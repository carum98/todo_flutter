import 'package:fluent_ui/fluent_ui.dart' hide IconButton;
import 'package:flutter/material.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/core/platform.dart';
import 'package:todo_flutter/features/lists/lists_form.dart';
import 'package:todo_flutter/features/lists/lists_tile.dart';
import 'package:todo_flutter/models/list_model.dart';
import 'package:todo_flutter/widgets/list_scaffold.dart';
import 'package:todo_flutter/widgets/platform_show_dialog.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({super.key});

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  void logout() {
    DI.of(context).authRepository.logout(context);
  }

  @override
  Widget build(BuildContext context) {
    final repo = DI.of(context).listRepository;

    return _ScaffoldPlatform(
      title: 'ToDo App',
      onAdd: () async {
        final item = await platformShowDialog(
          context: context,
          builder: () => const ListsForm(),
        );

        if (item != null) {
          setState(() {});
        }
      },
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
    );
  }
}

class _ScaffoldPlatform extends StatelessWidget {
  final String title;
  final Function() onAdd;
  final Widget body;

  const _ScaffoldPlatform({
    required this.title,
    required this.onAdd,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows) {
      return ScaffoldPage.withPadding(
        header: PageHeader(
          title: Text(title),
          commandBar: CommandBar(
            mainAxisAlignment: MainAxisAlignment.end,
            primaryItems: [
              CommandBarButton(
                icon: const Icon(FluentIcons.add),
                label: const Text('New'),
                onPressed: onAdd,
              ),
            ],
          ),
        ),
        content: Container(
          decoration: BoxDecoration(
            color: FluentThemeData.dark().scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: body,
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          leadingWidth: 0,
          leading: Container(),
        ),
        body: body,
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: onAdd,
          child: const Icon(Icons.add),
        ),
      );
    }
  }
}
