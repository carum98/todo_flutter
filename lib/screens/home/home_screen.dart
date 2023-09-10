import 'package:fluent_ui/fluent_ui.dart' hide Colors;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/core/platform.dart';
import 'package:todo_flutter/modules/lists/lists_form.dart';
import 'package:todo_flutter/models/list_model.dart';
import 'package:todo_flutter/widgets/context_menu.dart';
import 'package:todo_flutter/widgets/list_counter.dart';
import 'package:todo_flutter/widgets/platform_show_dialog.dart';
import 'package:yaru_widgets/widgets.dart';

import 'lists_screen.dart';
import 'todo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isLinux || Platform.isMacOS) {
      return const _ScaffoldPlatform();
    } else if (Platform.isWindows) {
      return const _LayoutWindows();
    }

    throw UnsupportedError('Unsupported platform');
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

class _ScaffoldPlatform extends StatefulWidget {
  const _ScaffoldPlatform();

  @override
  State<_ScaffoldPlatform> createState() => __ScaffoldPlatformState();
}

class __ScaffoldPlatformState extends State<_ScaffoldPlatform> {
  Widget pageBuilder(int id) => TodoScreen(listId: id);

  Future<void> dialog(ListModel? item) async {
    final data = await platformShowDialog(
      context: context,
      builder: () => ListsForm(item: item),
    );

    if (data != null) {
      setState(() {});
    }
  }

  Future<void> onRemove(ListModel item) async {
    final delete = await platformShowDialogAlert<bool>(
      context: context,
      title: 'Delete',
      content: 'Are you sure?',
    );

    if ((delete ?? false) && context.mounted) {
      await DI.of(context).listRepository.delete(item.id);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = DI.of(context).listRepository;

    if (Platform.isLinux) {
      return FutureBuilder(
        future: repo.getAll(),
        builder: (_, snapshot) {
          return YaruMasterDetailPage(
            length: snapshot.data?.length ?? 0,
            appBar: const YaruWindowTitleBar(
              title: Text('ToDo App'),
            ),
            tileBuilder: (_, index, selected, __) {
              final list = snapshot.data?[index] as ListModel;

              return ContextMenu(
                onDelete: () => onRemove(list),
                onEdit: () => dialog(list),
                child: YaruMasterTile(
                  leading: MacosIcon(
                    Icons.circle,
                    color: list.color,
                  ),
                  title: Text(list.name),
                  selected: selected,
                  trailing: ListCounter(count: list.count),
                ),
              );
            },
            bottomBar: TextButton.icon(
              onPressed: () => dialog(null),
              icon: const Icon(Icons.add),
              label: const Text('Add List'),
            ),
            pageBuilder: (_, index) => pageBuilder(snapshot.data![index].id),
          );
        },
      );
    }

    if (Platform.isMacOS) {
      final taskId = ValueNotifier<int?>(null);

      int index = 0;

      return MacosWindow(
        sidebar: Sidebar(
          minWidth: 200,
          builder: (_, __) {
            return FutureBuilder(
              future: repo.getAll(),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return SidebarItems(
                        currentIndex: index,
                        onChanged: (v) {
                          setState(() => index = v);
                          taskId.value = snapshot.data![v].id;
                        },
                        items: snapshot.data!
                            .map(
                              (e) => SidebarItem(
                                leading: MacosIcon(
                                  CupertinoIcons.circle_fill,
                                  color: e.color,
                                ),
                                label: ContextMenu(
                                  onDelete: () => onRemove(e),
                                  onEdit: () => dialog(e),
                                  child: Text(e.name),
                                ),
                                trailing: ListCounter(count: e.count),
                              ),
                            )
                            .toList(),
                      );
                    },
                  );
                }

                return Container();
              },
            );
          },
          bottom: TextButton.icon(
            onPressed: () => dialog(null),
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
              return pageBuilder(id);
            }

            return Container();
          },
        ),
      );
    }

    throw UnimplementedError();
  }
}
