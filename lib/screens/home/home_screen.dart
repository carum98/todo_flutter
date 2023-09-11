import 'package:fluent_ui/fluent_ui.dart' hide Colors;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:todo_flutter/bloc/lists_bloc.dart';
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

class _ScaffoldPlatform extends StatelessWidget {
  const _ScaffoldPlatform();

  @override
  Widget build(BuildContext context) {
    final bloc = DI.of(context).listBloc;

    bloc.onEvent(ListBlocGetAll());

    Future<void> dialog(ListModel? item) async {
      final data = await platformShowDialog(
        context: context,
        builder: () => ListsForm(item: item),
      );

      if (item == null) {
        bloc.onEvent(ListBlocAdd(data));
      } else {
        bloc.onEvent(ListBlocUpdate(data));
      }
    }

    Future<void> onRemove(ListModel item) async {
      final delete = await platformShowDialogAlert<bool>(
        context: context,
        title: 'Delete',
        content: 'Are you sure?',
      );

      if (delete == true) {
        bloc.onEvent(ListBlocDelete(item));
      }
    }

    if (Platform.isLinux) {
      return StreamBuilder(
        stream: bloc.stream,
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }

          final items = (snapshot.data as ListBlocLoaded).items;

          return YaruMasterDetailPage(
            length: items.length,
            appBar: const YaruWindowTitleBar(
              title: Text('ToDo App'),
            ),
            tileBuilder: (_, index, selected, __) {
              final list = items[index];

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
            pageBuilder: (_, index) => TodoScreen(
              key: Key(items[index].id.toString()),
              listId: items[index].id,
            ),
          );
        },
      );
    }

    if (Platform.isMacOS) {
      final taskId = ValueNotifier<int?>(null);

      int index = 0;

      return MacosWindow(
        sidebar: Sidebar(
          minWidth: 250,
          builder: (_, scrollController) {
            return StreamBuilder(
              stream: bloc.stream,
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }

                final items = (snapshot.data as ListBlocLoaded).items;

                return StatefulBuilder(
                  builder: (context, setState) {
                    return SidebarItems(
                      currentIndex: index,
                      scrollController: scrollController,
                      onChanged: (v) {
                        setState(() => index = v);
                        taskId.value = items[v].id;
                      },
                      items: items
                          .map(
                            (e) => SidebarItem(
                              leading: MacosIcon(
                                CupertinoIcons.circle_fill,
                                color: e.color,
                              ),
                              label: ContextMenu(
                                onDelete: () => onRemove(e),
                                onEdit: () => dialog(e),
                                child: Text(
                                  e.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              trailing: ListCounter(count: e.count),
                            ),
                          )
                          .toList(),
                    );
                  },
                );
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
              return TodoScreen(
                listId: id,
                key: Key(id.toString()),
              );
            }

            return Container();
          },
        ),
      );
    }

    throw UnimplementedError();
  }
}
