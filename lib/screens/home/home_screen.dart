import 'package:fluent_ui/fluent_ui.dart' hide Colors;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/core/platform.dart';
import 'package:todo_flutter/features/lists/lists_form.dart';
import 'package:todo_flutter/models/list_model.dart';
import 'package:todo_flutter/widgets/platform_show_dialog.dart';
import 'package:yaru_widgets/widgets.dart';

import 'lists_screen.dart';
import 'todo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isLinux) {
      return const _LayoutLinux();
    } else if (Platform.isWindows) {
      return const _LayoutWindows();
    } else {
      return const _LayoutMacos();
    }
  }
}

class _LayoutLinux extends StatelessWidget {
  const _LayoutLinux();

  @override
  Widget build(BuildContext context) {
    final repo = DI.of(context).listRepository;

    return Scaffold(
      body: FutureBuilder(
        future: repo.getAll(),
        builder: (_, snapshot) {
          return YaruMasterDetailPage(
            length: snapshot.data?.length ?? 0,
            appBar: const YaruWindowTitleBar(
              title: Text('ToDo App'),
            ),
            tileBuilder: (_, index, selected, __) {
              final list = snapshot.data?[index] as ListModel;

              return YaruMasterTile(
                leading: MacosIcon(
                  Icons.circle,
                  color: list.color,
                ),
                title: Text(list.name),
                selected: selected,
              );
            },
            bottomBar: TextButton.icon(
              onPressed: () async {
                final item = await platformShowDialog(
                  context: context,
                  builder: () => const ListsForm(),
                );

                if (item != null) {
                  print(item);
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add List'),
            ),
            pageBuilder: (_, index) {
              return TodoScreen(
                listId: snapshot.data![index].id,
              );
            },
          );
        },
      ),
    );
  }
}

class _LayoutWindows extends StatelessWidget {
  const _LayoutWindows();

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: const NavigationAppBar(
        title: Text('ToDo App'),
        automaticallyImplyLeading: false,
      ),
      pane: NavigationPane(
        displayMode: PaneDisplayMode.minimal,
        size: const NavigationPaneSize(openMaxWidth: 200),
        selected: 0,
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.list),
            title: const Text('Lists'),
            body: const ListsScreen(),
          ),
        ],
      ),
    );
  }
}

class _LayoutMacos extends StatelessWidget {
  const _LayoutMacos();

  @override
  Widget build(BuildContext context) {
    final repo = DI.of(context).listRepository;

    final taskId = ValueNotifier<int?>(null);

    return MacosWindow(
      sidebar: Sidebar(
        minWidth: 200,
        builder: (_, __) {
          return FutureBuilder(
            future: repo.getAll(),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return _List(
                  items: snapshot.data!,
                  onTap: (value) => taskId.value = value.id,
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          );
        },
        bottom: TextButton.icon(
          onPressed: () async {
            final item = await platformShowDialog(
              context: context,
              builder: () => const ListsForm(),
            );

            if (item != null) {
              print(item);
            }
          },
          icon: const MacosIcon(
            CupertinoIcons.add_circled,
            color: Colors.grey,
          ),
          label: const Text('New List'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey,
          ),
        ),
      ),
      child: ValueListenableBuilder<int?>(
        valueListenable: taskId,
        builder: (_, id, __) {
          if (id != null) {
            return TodoScreen(listId: id);
          }

          return const Center(child: Text('Select a list'));
        },
      ),
    );
  }
}

class _List extends StatefulWidget {
  final List<ListModel> items;
  final Function(ListModel) onTap;
  const _List({required this.items, required this.onTap});

  @override
  State<_List> createState() => __ListState();
}

class __ListState extends State<_List> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return SidebarItems(
      currentIndex: index,
      onChanged: (v) {
        setState(() => index = v);

        widget.onTap(widget.items[v]);
      },
      items: widget.items.map((e) {
        return SidebarItem(
          leading: MacosIcon(
            CupertinoIcons.circle_fill,
            color: e.color,
          ),
          label: Text(e.name),
        );
      }).toList(),
    );
  }
}
