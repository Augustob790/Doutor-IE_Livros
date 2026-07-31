import 'package:doutor_ie_test/core/iod.dart';
import 'package:doutor_ie_test/core/infra/app_api.dart';
import 'package:doutor_ie_test/core/infra/base_api.dart';
import 'package:doutor_ie_test/core/module.dart';
import 'package:doutor_ie_test/core/navigator/app_navigator.dart';
import 'package:doutor_ie_test/core/navigator/core_navigator.dart';
import 'package:doutor_ie_test/core/router.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';

class CoreModule extends Module {
  @override
  void initialize() {
    registerIoD();
    registerRoutes();
  }

  @override
  void registerIoD() {
    IoD.instance.registerSingleton<BaseApi>(AppApi());
  }

  @override
  void registerRoutes() {
    CoreRouter.registerRoutes(<RouteBase>[]);
  }

  void setupNavigation(GoRouter router) {
    IoD.instance.registerSingleton<AppNavigator>(CoreNavigator(router));
  }

  Future<void> initializeFormatter() async {
    await initializeDateFormatting('pt_BR', null);
  }
}
