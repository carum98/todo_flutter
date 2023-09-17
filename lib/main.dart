import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:todo_flutter/core/dependency_injector.dart';
import 'package:todo_flutter/router/router_generator.dart';
import 'package:todo_flutter/router/router_name.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_widgets/widgets.dart';

import 'core/platform.dart';
import 'core/theme.dart';
import 'services/storage_service.dart';
import 'services/token_service.dart';

void main() async {
  if (Platform.isLinux) {
    await YaruWindowTitleBar.ensureInitialized();
  }

  if (Platform.isMacOS) {
    await _configureMacosWindowUtils();
  }

  WidgetsFlutterBinding.ensureInitialized();

  final isAuth = await StorageService().containsKey(TokenService.storageName);

  runApp(DI(child: MyApp(isAuth: isAuth)));
}

class MyApp extends StatelessWidget {
  final bool isAuth;

  const MyApp({super.key, required this.isAuth});

  @override
  Widget build(BuildContext context) {
    if (Platform.isLinux) {
      return YaruTheme(
        data: const YaruThemeData(
          useMaterial3: true,
          variant: YaruVariant.blue,
        ),
        builder: (context, yaru, _) {
          return MaterialApp(
            title: 'ToDo App',
            theme: yaru.theme,
            darkTheme: yaru.darkTheme,
            debugShowCheckedModeBanner: false,
            initialRoute: isAuth ? HOME_PAGE : LOGIN_PAGE,
            onGenerateRoute: RouterGenerator.onGenerateRoute,
            navigatorKey: DI.of(context).navigatorKey,
          );
        },
      );
    }

    if (Platform.isWindows) {
      return FluentApp(
        title: 'ToDo App',
        themeMode: ThemeMode.dark,
        theme: ThemeController.light as FluentThemeData,
        darkTheme: ThemeController.dark as FluentThemeData,
        initialRoute: isAuth ? HOME_PAGE : LOGIN_PAGE,
        onGenerateRoute: RouterGenerator.onGenerateRoute,
        navigatorKey: DI.of(context).navigatorKey,
        debugShowCheckedModeBanner: false,
      );
    }

    if (Platform.isMacOS) {
      return MacosApp(
        title: 'ToDo App',
        theme: ThemeController.light as MacosThemeData,
        darkTheme: ThemeController.dark as MacosThemeData,
        initialRoute: isAuth ? HOME_PAGE : LOGIN_PAGE,
        onGenerateRoute: RouterGenerator.onGenerateRoute,
        navigatorKey: DI.of(context).navigatorKey,
        debugShowCheckedModeBanner: false,
      );
    }

    if (Platform.isIOS) {
      return CupertinoApp(
        title: 'ToDo App',
        theme: ThemeController.dark as CupertinoThemeData,
        initialRoute: isAuth ? HOME_PAGE : LOGIN_PAGE,
        onGenerateRoute: RouterGenerator.onGenerateRoute,
        navigatorKey: DI.of(context).navigatorKey,
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
      );
    }

    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeController.light as ThemeData,
      darkTheme: ThemeController.dark as ThemeData,
      debugShowCheckedModeBanner: false,
      initialRoute: isAuth ? HOME_PAGE : LOGIN_PAGE,
      onGenerateRoute: RouterGenerator.onGenerateRoute,
      navigatorKey: DI.of(context).navigatorKey,
    );
  }
}

/// This method initializes macos_window_utils and styles the window.
Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig(
    toolbarStyle: NSWindowToolbarStyle.unified,
  );
  await config.apply();
}
