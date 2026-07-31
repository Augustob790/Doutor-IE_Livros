import 'package:doutor_ie_test/core/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CoreRouter {
  CoreRouter._();

  static final List<RouteBase> _routes = <RouteBase>[];

  static void registerRoutes(List<RouteBase> routes) {
    _routes.addAll(routes);
  }

  static GoRouter initRouter(AppState appState) {
    return GoRouter(
      refreshListenable: appState,
      initialLocation: "/",
      redirect: (context, state) {
        logDebug("App State: ${appState.isLogged}, ${appState.canStartApp}");
        if (appState.canStartApp == null) {
          return '/';
        }
        if (appState.canStartApp == true && state.uri.path == '/') {
          return appState.isLogged ? '/livros' : '/login';
        }
        if (appState.canStartApp == true &&
            !appState.isLogged &&
            state.uri.path.startsWith('/livros')) {
          return '/login';
        }
        return null;
      },
      routes: _routes,
    );
  }
}

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;

  AppState._internal();

  bool? _canStartApp;
  bool _isLogged = false;
  bool _isInitialized = false;
  bool _isAnimationComplete = false;
  bool _hasError = false;
  bool _hasRedirect = false;
  String? _redirectPath = '';
  ThemeMode _themeMode = ThemeMode.light;

  bool? get canStartApp => _canStartApp;
  bool get isLogged => _isLogged;
  bool get isInitialized => _isInitialized;
  bool get isAnimationComplete => _isAnimationComplete;
  bool get hasError => _hasError;
  bool get hasRedirect => _hasRedirect;
  String? get redirectPath => _redirectPath;
  ThemeMode get themeMode => _themeMode;

  bool get isReadyToTransition =>
      _isInitialized && _isAnimationComplete && !_hasError;

  void setCanStartApp(bool? value) {
    _canStartApp = value;
    notifyListeners();
  }

  void setIsLogged(bool value) {
    _isLogged = value;
    notifyListeners();
  }

  void setInitialized(bool value) {
    _isInitialized = value;
    notifyListeners();
  }

  void setAnimationComplete(bool value) {
    _isAnimationComplete = value;
    notifyListeners();
  }

  void setError(bool value) {
    _hasError = value;
    notifyListeners();
  }

  void setRedirect(bool value) {
    _redirectPath = '';
    _hasRedirect = value;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void restart() {
    _canStartApp = null;
    _isLogged = false;
    _isInitialized = false;
    _isAnimationComplete = false;
    _hasError = false;
    _hasRedirect = false;
    _redirectPath = '';
    notifyListeners();
  }
}
