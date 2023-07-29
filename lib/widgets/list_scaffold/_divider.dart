part of 'list_scaffold.dart';

class _Divider extends StatelessWidget {
  final Widget child;
  final bool isLast;
  final bool enabled;

  const _Divider({
    super.key,
    required this.child,
    required this.isLast,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      decoration: enabled
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isLast ? Colors.transparent : Colors.grey,
                  width: 0.5,
                ),
              ),
            )
          : null,
      child: child,
    );
  }
}
