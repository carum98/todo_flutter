import 'package:flutter/widgets.dart';
import 'package:todo_flutter/repository/auth_repository.dart';
import 'package:todo_flutter/repository/list_respository.dart';
import 'package:todo_flutter/services/api_service.dart';
import 'package:todo_flutter/services/auth_service.dart';
import 'package:todo_flutter/services/list_service.dart';
import 'package:todo_flutter/services/storage_service.dart';
import 'package:todo_flutter/services/token_service.dart';

class DI extends InheritedWidget {
  final BuildContext context;

  late final StorageService storage;
  late final AuthRepository authRepository;
  late final ListRepository listRepository;

  late final TokenService _tokenService;
  late final ApiService _apiService;
  late final ListService _listService;

  DI({
    super.key,
    required this.context,
    required super.child,
  }) {
    storage = StorageService();

    _tokenService = TokenService(storage: storage);

    _apiService = ApiService(
      context: context,
      tokenService: _tokenService,
    );

    _listService = ListService(
      api: _apiService,
    );

    authRepository = AuthRepository(
      tokenService: _tokenService,
      api: AuthService(api: _apiService.copyWith(useToken: false)),
    );

    listRepository = ListRepository(
      api: _listService,
    );
  }

  static DI of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DI>() as DI;
  }

  @override
  bool updateShouldNotify(DI oldWidget) => false;
}
