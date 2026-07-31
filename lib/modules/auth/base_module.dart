import 'package:doutor_ie_test/core/infra/base_api.dart';
import 'package:doutor_ie_test/core/infra/login_session_storage.dart';
import 'package:doutor_ie_test/core/iod.dart';
import 'package:doutor_ie_test/core/module.dart';
import 'package:doutor_ie_test/core/router.dart';
import 'package:doutor_ie_test/modules/auth/auth_routes.dart';
import 'package:doutor_ie_test/modules/auth/domain/repositories/auth_repository.dart';
import 'package:doutor_ie_test/modules/auth/infra/repositories/auth_repository_impl.dart';
import 'package:doutor_ie_test/modules/auth/ui/login_viewmodel.dart';

class AuthModule extends Module {
  @override
  void initialize() {
    registerIoD();
    registerRoutes();
  }

  @override
  void registerIoD() {
    IoD.instance.registerLazySingleton<AuthRepository>(
        AuthRepositoryImpl(api: IoD.instance.get<BaseApi>()));
    IoD.instance
        .registerLazySingleton<LoginSessionStorage>(LoginSessionStorage());
    IoD.instance.registerFactory<LoginViewModel>(
      () => LoginViewModel(
        repository: IoD.instance.get<AuthRepository>(),
        sessionStorage: IoD.instance.get<LoginSessionStorage>(),
      ),
    );
  }

  @override
  void registerRoutes() => CoreRouter.registerRoutes(authRoutes);
}
