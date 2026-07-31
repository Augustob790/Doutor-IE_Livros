import 'package:doutor_ie_test/core/iod.dart';
import 'package:doutor_ie_test/core/module.dart';
import 'package:doutor_ie_test/core/router.dart';
import 'package:doutor_ie_test/modules/auth/base_module.dart';
import 'package:doutor_ie_test/modules/books/base_module.dart';

class BaseModule extends Module {
  final List<Module> _modules = <Module>[AuthModule(), BooksModule()];

  @override
  void initialize() {
    registerIoD();
    registerRoutes();
  }

  @override
  void registerIoD() {
    IoD.instance.registerSingleton<AppState>(AppState());

    for (final Module module in _modules) {
      module.registerIoD();
    }
  }

  @override
  void registerRoutes() {
    for (final Module module in _modules) {
      module.registerRoutes();
    }
  }
}
