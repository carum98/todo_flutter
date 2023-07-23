import 'dart:async';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/models/list_model.dart';
import 'package:todo_flutter/router/router_name.dart';
import 'package:todo_flutter/services/api_service.dart'
    show UnauthorizedException;
import 'package:todo_flutter/widgets/form_scaffold.dart';
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
              formBuilder: (item) => _Form(item: item),
              indentifierBuilder: (item) => item.id,
              itemBuilder: (item, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: _Tile(item: item),
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
              child: _Form(),
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

class _Tile extends StatelessWidget {
  final ListModel item;
  const _Tile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.circle, color: Colors.white, size: 20),
          Icon(Icons.circle, color: item.color, size: 18),
        ],
      ),
      title: Text(
        item.name,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      tileColor: Theme.of(context).colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onTap: () {
        Navigator.pushNamed(context, TODO_PAGE, arguments: item.id);
      },
    );
  }
}

class _Form extends StatelessWidget {
  final ListModel? item;

  const _Form({this.item});

  @override
  Widget build(BuildContext context) {
    final repo = DI.of(context).listRepository;

    final name = ValueNotifier(item?.name ?? '');
    final color = ValueNotifier(item?.color ?? const Color(0xfff44336));

    Future<void> send() async {
      final nameValue = name.value.trim();
      final colorValue = '#${color.value.hex}';

      final data = (name: nameValue, color: colorValue);

      final value = item != null
          ? await repo.update(item!.id, data)
          : await repo.add(data);

      if (context.mounted) {
        Navigator.pop(context, value);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: FormScaffold(
        buttonTitle: item != null ? 'Update' : 'Create',
        values: [name],
        onSend: send,
        children: [
          TextFormField(
            initialValue: name.value,
            decoration: const InputDecoration(hintText: 'Name'),
            autofocus: true,
            onChanged: (value) => name.value = value,
          ),
          ColorPicker(
            color: color.value,
            onColorChanged: (Color value) => color.value = value,
            enableShadesSelection: false,
            padding: EdgeInsets.zero,
            pickersEnabled: const <ColorPickerType, bool>{
              ColorPickerType.accent: false,
            },
          ),
        ],
      ),
    );
  }
}
