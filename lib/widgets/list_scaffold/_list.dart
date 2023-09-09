part of 'list_scaffold.dart';

class _List<T> extends StatelessWidget {
  final List<T> items;
  final bool reorderable;
  final Widget Function(T, int) itemBuilder;

  const _List({
    super.key,
    required this.items,
    required this.reorderable,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (reorderable) {
      return ReorderableListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: items.length,
        onReorder: _Controller.of(context)!.move,
        itemBuilder: (_, index) {
          final item = items[index];

          return itemBuilder(item, index);
        },
      );
    } else {
      if (Platform.isIOS) {
        final children = items
            .map((item) => itemBuilder(item, items.indexOf(item)))
            .toList();

        return SingleChildScrollView(
          child: CupertinoListSection.insetGrouped(
            additionalDividerMargin: 30,
            children: children,
          ),
        );
      } else {
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: items.length,
          itemBuilder: (_, index) {
            final item = items[index];

            return itemBuilder(item, index);
          },
        );
      }
    }
  }
}
