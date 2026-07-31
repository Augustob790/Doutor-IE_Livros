import 'package:doutor_ie_test/core/infra/base_response.dart';
import 'package:doutor_ie_test/modules/auth/domain/models/login_credentials.dart';
import 'package:doutor_ie_test/modules/auth/domain/models/login_response_model.dart';

abstract class AuthRepository {
  Future<BaseResponse<LoginResponseModel>> login(LoginCredentials credentials);
}
