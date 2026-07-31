import 'package:doutor_ie_test/modules/auth/domain/models/login_credentials.dart';
import 'package:doutor_ie_test/modules/auth/domain/models/login_response_model.dart';
import 'package:doutor_ie_test/modules/auth/infra/data_models/login_data_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('serializa as credenciais no payload de login da API', () {
    final json = LoginDataModel.toJson(const LoginCredentials(
      email: 'seu@email.com',
      password: '123456',
    ));

    expect(json, <String, String>{
      'email': 'seu@email.com',
      'senha': '123456',
    });
  });

  test('converte a resposta de login com usuário e token', () {
    final response = LoginResponseModel.fromJson(<String, dynamic>{
      'user': <String, dynamic>{
        'id': 24,
        'name': 'Augusto Batista',
        'email': 'augustosousa790@gmail.com',
        'email_verified_at': null,
      },
      'token': '1144|885amJVBh4FXFgELzx9MRDioFxZetd6UsBDELwiH',
    });

    expect(response.user.id, '24');
    expect(response.user.emailVerified, isFalse);
    expect(response.token, isNotEmpty);
  });
}
