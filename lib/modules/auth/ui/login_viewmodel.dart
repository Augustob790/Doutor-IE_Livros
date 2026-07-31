import 'package:doutor_ie_test/core/i18n/i18n_loader.dart';
import 'package:doutor_ie_test/core/infra/login_session_storage.dart';
import 'package:doutor_ie_test/core/infra/base_response.dart';
import 'package:doutor_ie_test/core/utils/log.dart';
import 'package:doutor_ie_test/core/viewmodels/async_viewmodel.dart';
import 'package:doutor_ie_test/modules/auth/domain/repositories/auth_repository.dart';
import 'package:doutor_ie_test/modules/auth/domain/models/login_credentials.dart';
import 'package:doutor_ie_test/modules/auth/domain/models/login_response_model.dart';
import 'package:doutor_ie_test/modules/auth/auth_string_keys.dart';
import 'package:doutor_ie_test/modules/books/strings.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier with AsyncViewModel {
  LoginViewModel(
      {required AuthRepository repository,
      required LoginSessionStorage sessionStorage})
      : _repository = repository,
        _sessionStorage = sessionStorage;

  final AuthRepository _repository;
  final LoginSessionStorage _sessionStorage;
  final I18nLoader _i18n = I18nLoader(strings);
  final ValueNotifier<BaseResponse<LoginResponseModel>> loginResponse =
      ValueNotifier<BaseResponse<LoginResponseModel>>(
          BaseResponse<LoginResponseModel>.none());

  Future<bool> login(String email, String password) async {
    setLoading();
    loginResponse.value = BaseResponse<LoginResponseModel>.loading();
    try {
      final response = await _repository.login(LoginCredentials(
        email: email.trim(),
        password: password,
      ));
      loginResponse.value = response;
      if (!response.isSuccess || response.data == null) {
        setError(response.error?.message ??
            _i18n.getText(AuthStringKeys.loginError));
        return false;
      }
      await _sessionStorage.saveToken(response.data!.token);
      setSuccess();
      return true;
    } catch (error) {
      logDebug('Erro ao realizar login: $error');
      loginResponse.value = BaseResponse<LoginResponseModel>.genericError();
      setError(_i18n.getText(AuthStringKeys.loginError));
      return false;
    }
  }

  @override
  void dispose() {
    loginResponse.dispose();
    super.dispose();
  }
}
