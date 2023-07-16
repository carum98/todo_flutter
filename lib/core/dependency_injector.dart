import 'package:flutter/widgets.dart';
import 'package:todo_flutter/repository/auth_repository.dart';
import 'package:todo_flutter/services/auth_service.dart';
import 'package:todo_flutter/services/storage_service.dart';

class DI extends InheritedWidget {
  late final StorageService storage;
  late final AuthRepository authRepository;

  DI({super.key, required super.child}) {
    storage = StorageService();
    authRepository = AuthRepository(storage: storage, api: AuthService());
  }

  static DI of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DI>() as DI;
  }

  @override
  bool updateShouldNotify(DI oldWidget) => false;
}
