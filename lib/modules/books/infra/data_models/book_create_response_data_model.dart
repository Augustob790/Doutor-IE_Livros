import 'package:doutor_ie_test/modules/books/domain/models/book_create_response.dart';

class BookCreateResponseDataModel {
  const BookCreateResponseDataModel._();

  static BookCreateResponse fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = Map<String, dynamic>.from(
      json['data'] ?? json['result'] ?? json,
    );
    return BookCreateResponse(
      id: (data['id'] ?? data['_id'] ?? '').toString(),
      publisherUserId:
          (data['usuario_publicador_id'] ?? data['publisher_user_id'] ?? '')
              .toString(),
      title: (data['titulo'] ?? data['title'] ?? '').toString(),
      createdAt: DateTime.tryParse((data['created_at'] ?? '').toString()),
      updatedAt: DateTime.tryParse((data['updated_at'] ?? '').toString()),
    );
  }
}
