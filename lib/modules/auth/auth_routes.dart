import 'package:doutor_ie_test/base_routes.dart';
import 'package:doutor_ie_test/core/iod.dart';
import 'package:doutor_ie_test/modules/auth/ui/login_screen.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> authRoutes = [
  GoRoute(
    path: AppRoutesPath.login,
    builder: (_, __) => LoginScreen(viewModel: IoD.instance.get()),
  )
];
