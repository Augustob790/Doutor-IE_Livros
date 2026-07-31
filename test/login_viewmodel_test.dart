import 'package:doutor_ie_test/core/infra/base_response.dart';
import 'package:doutor_ie_test/core/infra/login_session_storage.dart';
import 'package:doutor_ie_test/modules/auth/domain/models/auth_me_model.dart';
import 'package:doutor_ie_test/modules/auth/domain/models/login_credentials.dart';
import 'package:doutor_ie_test/modules/auth/domain/models/login_response_model.dart';
import 'package:doutor_ie_test/modules/auth/domain/repositories/auth_repository.dart';
import 'package:doutor_ie_test/modules/auth/ui/login_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late _MockSessionStorage storage;

  setUp(() {
    storage = _MockSessionStorage();
    when(() => storage.saveToken(any())).thenAnswer((_) async {});
  });

  test('normaliza e-mail e persiste token após autenticação', () async {
    final repository = _FakeAuthRepository();
    final viewModel = LoginViewModel(
      repository: repository,
      sessionStorage: storage,
    );

    final authenticated = await viewModel.login('  usuario@teste.com ', '123456');

    expect(authenticated, isTrue);
    expect(repository.credentials?.email, 'usuario@teste.com');
    verify(() => storage.saveToken('token-123')).called(1);
    expect(viewModel.errorMessage, isNull);
  });

  test('não persiste token e expõe erro quando autenticação falha', () async {
    final viewModel = LoginViewModel(
      repository: _FakeAuthRepository(succeeds: false),
      sessionStorage: storage,
    );

    final authenticated = await viewModel.login('usuario@teste.com', '123456');

    expect(authenticated, isFalse);
    verifyNever(() => storage.saveToken(any()));
    expect(viewModel.errorMessage, isNotNull);
  });
}

class _MockSessionStorage extends Mock implements LoginSessionStorage {}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.succeeds = true});

  final bool succeeds;
  LoginCredentials? credentials;

  @override
  Future<BaseResponse<LoginResponseModel>> login(
    LoginCredentials credentials,
  ) async {
    this.credentials = credentials;
    if (!succeeds) return BaseResponse<LoginResponseModel>.genericError();
    return BaseResponse<LoginResponseModel>.success(
      statusCode: 200,
      data: const LoginResponseModel(
        user: AuthMeModel(
          id: '1',
          name: 'Usuário',
          email: 'usuario@teste.com',
          emailVerified: false,
        ),
        token: 'token-123',
      ),
    );
  }
}
