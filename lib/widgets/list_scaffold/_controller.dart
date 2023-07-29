// ignore_for_file: invalid_use_of_protected_member

part of 'list_scaffold.dart';

class _Controller<T extends Identifiable> extends InheritedWidget {
  final _ListScaffoldState state;

  const _Controller({
    Key? key,
    required this.state,
    required Widget child,
  }) : super(key: key, child: child);

  static _Controller? of<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_Controller>();
  }

  // Move
  Future<void> move(int oldIndex, int newIndex) async {
    final index = newIndex > oldIndex ? newIndex - 1 : newIndex;
    final item = state.widget.items[oldIndex];

    state.setState(() {
      state.widget.items.removeAt(oldIndex);
      state.widget.items.insert(index, item);
    });

    state.widget.repository.move(item.id, newIndex).onError((_, __) {
      state.setState(() {
        state.widget.items.removeAt(index);
        state.widget.items.insert(oldIndex, item);
      });
    });
  }

  // Delete
  Future<void> delete(T item, int index) async {
    final item = state.widget.items[index];

    state.setState(() {
      state.widget.items.removeAt(index);
    });

    state.widget.repository.delete(item.id).onError((_, __) {
      state.setState(() {
        state.widget.items.insert(index, item);
      });
    });
  }

  // Edit
  Future<void> edit(T item, int index) async {
    final data = await platformShowDialog(
      context: state.context,
      builder: () => state.widget.formBuilder(item),
    );

    if (data == null) return;

    state.widget.items.removeAt(index);
    state.widget.items.insert(index, data);

    state.setState(() {});
  }

  Future<bool> deleteConfirmation() async {
    return await platformShowDialogAlert(
      context: state.context,
      title: 'Delete',
      content: 'Are you sure?',
    );
  }

  @override
  bool updateShouldNotify(_Controller oldWidget) => false;
}
