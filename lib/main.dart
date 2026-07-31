import 'package:doutor_ie_test/app_env.dart';
import 'package:doutor_ie_test/base_module.dart';
import 'package:doutor_ie_test/core/core_module.dart';
import 'package:doutor_ie_test/core/infra/login_session_storage.dart';
import 'package:doutor_ie_test/core/iod.dart';
import 'package:doutor_ie_test/core/router.dart';
import 'package:doutor_ie_test/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppEnv.load();
  AppEnv.validate();

  final CoreModule coreModule = CoreModule();
  coreModule.initialize();
  await coreModule.initializeFormatter();
  BaseModule().initialize();

  final AppState appState = IoD.instance.get<AppState>();
  final String? token =
      await IoD.instance.get<LoginSessionStorage>().getToken();
  appState.setIsLogged(token?.isNotEmpty == true);
  appState.setCanStartApp(true);

  final GoRouter router = CoreRouter.initRouter(appState);
  coreModule.setupNavigation(router);

  runApp(ArchitectureApp(router: router, appState: appState));
}

class ArchitectureApp extends StatelessWidget {
  const ArchitectureApp({
    super.key,
    required this.router,
    required this.appState,
  });

  final GoRouter router;
  final AppState appState;
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (BuildContext context, Widget? child) => MaterialApp.router(
        title: 'Doutor-IE Livros',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appState.themeMode,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('pt', 'BR'),
        ],
      ),
    );
  }
}
