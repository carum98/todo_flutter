import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/core/platform.dart';
import 'package:todo_flutter/features/todos/todos_form.dart';
import 'package:todo_flutter/features/todos/todos_tile.dart';
import 'package:todo_flutter/models/todo_model.dart';
import 'package:todo_flutter/widgets/list_scaffold.dart';
import 'package:todo_flutter/widgets/platform_show_dialog.dart';
import 'package:yaru_widgets/widgets.dart';

class TodoScreen extends StatefulWidget {
  final int listId;
  const TodoScreen({super.key, required this.listId});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    final repo = DI.of(context).todoRepository;

    return _ScaffoldPlatform(
      title: 'ToDos',
      onAdd: () async {
        final item = await platformShowDialog(
          context: context,
          builder: () => TodosForm(listId: widget.listId),
        );

        if (item != null) {
          setState(() {});
        }
      },
      body: FutureBuilder(
        future: repo.getTodos(widget.listId),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return ListScaffold(
              items: snapshot.data as List<TodoModel>,
              repository: repo,
              reorderable: true,
              formBuilder: (item) => TodosForm(
                item: item,
                listId: widget.listId,
              ),
              indentifierBuilder: (item) => item.id,
              itemBuilder: (item, index) => ToDoTile(
                item: item,
                onTap: () => repo.toggle(item.id),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
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
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(title),
          trailing: CupertinoButton(
            onPressed: onAdd,
            child: const Icon(CupertinoIcons.add),
          ),
        ),
        child: SafeArea(
          child: body,
        ),
      );
    } else if (Platform.isLinux) {
      return YaruDetailPage(
        appBar: YaruWindowTitleBar(
          title: Text(title),
        ),
        body: body,
        floatingActionButton: FloatingActionButton(
          onPressed: onAdd,
          child: const Icon(Icons.add),
        ),
      );
    } else if (Platform.isWindows) {
      return NavigationView(
        appBar: NavigationAppBar(
          title: Text(title),
        ),
        content: ScaffoldPage.withPadding(
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
        ),
      );
    } else if (Platform.isMacOS) {
      return MacosScaffold(
        toolBar: ToolBar(
          title: Text(title),
          automaticallyImplyLeading: false,
          actions: [
            ToolBarIconButton(
              label: "Add",
              icon: const MacosIcon(
                CupertinoIcons.add_circled,
              ),
              onPressed: onAdd,
              showLabel: false,
            ),
          ],
        ),
        children: [
          ContentArea(
            builder: (__, _) {
              return body;
            },
          ),
        ],
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
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
