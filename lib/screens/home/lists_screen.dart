import 'package:fluent_ui/fluent_ui.dart' hide IconButton;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/bloc/lists_bloc.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/core/platform.dart';
import 'package:todo_flutter/modules/lists/lists_form.dart';
import 'package:todo_flutter/modules/lists/lists_tile.dart';
import 'package:todo_flutter/widgets/list_scaffold/list_scaffold.dart';
import 'package:todo_flutter/widgets/platform_show_dialog.dart';

class ListsScreen extends StatelessWidget {
  const ListsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = DI.of(context).listBloc;

    bloc.onEvent(ListBlocGetAll());

    return _ScaffoldPlatform(
      title: 'ToDo App',
      onAdd: () async {
        final item = await platformShowDialog(
          context: context,
          builder: () => const ListsForm(),
        );

        if (item != null) {
          bloc.onEvent(ListBlocAdd(item));
        }
      },
      body: StreamBuilder(
        stream: bloc.stream,
        builder: (_, snapshot) {
          if (snapshot.data is ListBlocLoaded) {
            return ListScaffold(
              items: (snapshot.data as ListBlocLoaded).items,
              repository: DI.of(context).listRepository,
              formBuilder: (item) => ListsForm(item: item),
              itemBuilder: (item, index) => ListsTile(item: item),
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
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          automaticallyImplyLeading: false,
          middle: Text(title),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onAdd,
            child: const Icon(CupertinoIcons.add),
          ),
        ),
        child: SafeArea(
          child: body,
        ),
      );
    } else if (Platform.isWindows) {
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
