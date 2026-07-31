import 'package:doutor_ie_test/core/iod.dart';
import 'package:doutor_ie_test/core/navigator/app_navigator.dart';
import 'package:doutor_ie_test/core/router.dart';
import 'package:go_router/go_router.dart';

class CoreNavigator extends AppNavigator {
  final GoRouter _router;

  CoreNavigator(this._router);

  @override
  Future<T?> push<T extends Object?>(String path, {Object? extra}) {
    return _router.push<T>(path, extra: extra);
  }

  @override
  Future<T?> pushReplacement<T extends Object?>(String path, {Object? extra}) {
    return _router.pushReplacement<T>(path, extra: extra);
  }

  @override
  void pop<T extends Object?>({T? result}) {
    if (_router.canPop()) {
      _router.pop(result);
    } else if (IoD.instance.get<AppState>().isLogged) {
      _router.go("/home");
    } else {
      _router.go("/login");
    }
  }

  @override
  void go(String path, {Object? extra}) {
    return _router.go(path, extra: extra);
  }
}
