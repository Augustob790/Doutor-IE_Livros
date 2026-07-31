import 'package:doutor_ie_test/modules/auth/domain/models/auth_me_model.dart';

class LoginResponseModel {
  final AuthMeModel user;
  final String token;

  const LoginResponseModel({required this.user, required this.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = Map<String, dynamic>.from(
      json['data'] ?? json['result'] ?? json,
    );
    return LoginResponseModel(
      user: AuthMeModel.fromJson(data),
      token: (data['token'] ?? data['access_token'] ?? data['jwt'] ?? '')
          .toString(),
    );
  }
}
