import 'package:doutor_ie_test/modules/books/infra/data_models/book_create_response_data_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('converte a resposta 201 do cadastro de livro', () {
    final result = BookCreateResponseDataModel.fromJson(<String, dynamic>{
      'usuario_publicador_id': 24,
      'titulo': 'Livro 01',
      'updated_at': '2026-07-31T19:50:35.000000Z',
      'created_at': '2026-07-31T19:50:35.000000Z',
      'id': 300,
    });
    expect(result.id, '300');
    expect(result.publisherUserId, '24');
    expect(result.title, 'Livro 01');
    expect(result.createdAt, isNotNull);
  });
}
