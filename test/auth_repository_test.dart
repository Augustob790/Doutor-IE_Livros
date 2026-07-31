import 'package:doutor_ie_test/core/infra/base_api.dart';
import 'package:doutor_ie_test/core/infra/base_response.dart';
import 'package:doutor_ie_test/modules/auth/domain/models/login_credentials.dart';
import 'package:doutor_ie_test/modules/auth/infra/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('envia credenciais e converte usuário e token do login', () async {
    final api = _FakeApi(<String, dynamic>{
      'user': <String, dynamic>{
        'id': 24,
        'name': 'Augusto',
        'email': 'a@b.com'
      },
      'token': 'token-123',
    });
    final response = await AuthRepositoryImpl(api: api).login(
      const LoginCredentials(email: 'a@b.com', password: '123456'),
    );

    expect(api.body, <String, String>{'email': 'a@b.com', 'senha': '123456'});
    expect(response.isSuccess, isTrue);
    expect(response.data!.user.id, '24');
    expect(response.data!.token, 'token-123');
  });
}

class _FakeApi implements BaseApi {
  _FakeApi(this.response);
  final Map<String, dynamic> response;
  dynamic body;
  @override
  Future<BaseResponse<Map<String, dynamic>>> post(String path, dynamic value,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    body = value;
    return BaseResponse<Map<String, dynamic>>.success(
        data: response, statusCode: 200);
  }

  @override
  Future<BaseResponse<Map<String, dynamic>>> delete(String path,
          {Map<String, dynamic>? queryParameters,
          Map<String, dynamic>? headers}) =>
      throw UnimplementedError();
  @override
  Future<BaseResponse<Map<String, dynamic>>> get(String path,
          {Map<String, dynamic>? queryParameters,
          Map<String, dynamic>? headers}) =>
      throw UnimplementedError();
  @override
  Future<BaseResponse<Map<String, dynamic>>> patch(String path, dynamic body,
          {Map<String, dynamic>? queryParameters,
          Map<String, dynamic>? headers}) =>
      throw UnimplementedError();
  @override
  Future<BaseResponse<Map<String, dynamic>>> put(String path, dynamic body,
          {Map<String, dynamic>? queryParameters,
          Map<String, dynamic>? headers}) =>
      throw UnimplementedError();
}
