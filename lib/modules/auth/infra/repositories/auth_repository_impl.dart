import 'package:doutor_ie_test/core/infra/api_endpoints.dart';
import 'package:doutor_ie_test/core/infra/base_api.dart';
import 'package:doutor_ie_test/core/infra/base_response.dart';
import 'package:doutor_ie_test/modules/auth/domain/models/login_credentials.dart';
import 'package:doutor_ie_test/modules/auth/domain/models/login_response_model.dart';
import 'package:doutor_ie_test/modules/auth/domain/repositories/auth_repository.dart';
import 'package:doutor_ie_test/modules/auth/infra/data_models/login_data_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required BaseApi api}) : _api = api;

  final BaseApi _api;

  @override
  Future<BaseResponse<LoginResponseModel>> login(
      LoginCredentials credentials) async {
    try {
      final response = await _api.post(
        ApiEndpoints.login,
        LoginDataModel.toJson(credentials),
      );
      if (!response.isSuccess || response.data == null) {
        return BaseResponse<LoginResponseModel>.error(response.statusCode,
            error: response.error);
      }
      final login = LoginResponseModel.fromJson(response.data!);
      if (login.token.trim().isEmpty) {
        return BaseResponse<LoginResponseModel>.genericError();
      }
      return BaseResponse<LoginResponseModel>.success(
          data: login, statusCode: response.statusCode);
    } catch (_) {
      return BaseResponse<LoginResponseModel>.genericError();
    }
  }
}
