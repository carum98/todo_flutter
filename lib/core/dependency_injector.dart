import 'package:flutter/widgets.dart';
import 'package:todo_flutter/bloc/lists_bloc.dart';
import 'package:todo_flutter/repository/auth_repository.dart';
import 'package:todo_flutter/repository/list_respository.dart';
import 'package:todo_flutter/repository/todo_repository.dart';
import 'package:todo_flutter/services/api_service.dart';
import 'package:todo_flutter/services/auth_service.dart';
import 'package:todo_flutter/services/list_service.dart';
import 'package:todo_flutter/services/storage_service.dart';
import 'package:todo_flutter/services/todo_service.dart';
import 'package:todo_flutter/services/token_service.dart';

class DI extends InheritedWidget {
  late final StorageService storage;
  late final AuthRepository authRepository;
  late final ListRepository listRepository;
  late final TodoRepository todoRepository;

  late final GlobalKey<NavigatorState> navigatorKey;

  late final TokenService _tokenService;
  late final ApiService _apiService;
  late final ListService _listService;
  late final TodoService _todoService;

  late final ListBloc listBloc;

  DI({
    super.key,
    required super.child,
  }) {
    navigatorKey = GlobalKey<NavigatorState>();

    storage = StorageService();

    _tokenService = TokenService(storage: storage);

    _apiService = ApiService(
      tokenService: _tokenService,
      navigatorKey: navigatorKey,
    );

    _listService = ListService(
      api: _apiService,
    );

    _todoService = TodoService(
      api: _apiService,
    );

    authRepository = AuthRepository(
      tokenService: _tokenService,
      api: AuthService(api: _apiService.copyWith(useToken: false)),
    );

    listRepository = ListRepository(
      api: _listService,
    );

    todoRepository = TodoRepository(
      api: _todoService,
    );

    listBloc = ListBloc(
      repository: listRepository,
    );
  }

  static DI of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DI>() as DI;
  }

  Stream<ApiServiceException> get onApiError => _apiService.onError;

  @override
  bool updateShouldNotify(DI oldWidget) => false;
}
