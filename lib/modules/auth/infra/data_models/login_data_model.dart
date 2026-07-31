import 'package:doutor_ie_test/modules/auth/domain/models/login_credentials.dart';

class LoginDataModel {
  const LoginDataModel._();

  static Map<String, String> toJson(LoginCredentials credentials) {
    return <String, String>{
      'email': credentials.email,
      'senha': credentials.password,
    };
  }
}
