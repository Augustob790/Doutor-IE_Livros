import 'package:doutor_ie_test/modules/books/domain/models/book_detail_response.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book_mutation_response.dart';

class BookResponseDataModel {
  const BookResponseDataModel._();
  static BookMutationResponse mutationFromJson(Map<String, dynamic> json) =>
      BookMutationResponse(
        id: (json['id'] ?? '').toString(),
        publisherUserId: (json['usuario_publicador_id'] ?? '').toString(),
        title: (json['titulo'] ?? '').toString(),
        createdAt: DateTime.tryParse((json['created_at'] ?? '').toString()),
        updatedAt: DateTime.tryParse((json['updated_at'] ?? '').toString()),
        deletedAt: DateTime.tryParse((json['deleted_at'] ?? '').toString()),
      );

  static BookDetailResponse detailFromJson(Map<String, dynamic> json) {
    final publisher = json['usuario_publicador'];
    return BookDetailResponse(
        id: (json['id'] ?? '').toString(),
        title: (json['titulo'] ?? '').toString(),
        publisher: publisher is Map
            ? BookPublisherResponse(
                id: (publisher['id'] ?? '').toString(),
                name: (publisher['nome'] ?? publisher['name'] ?? '').toString(),
              )
            : null,
        indexes: _indexes(json['indices']));
  }

  static List<BookIndexResponse> _indexes(dynamic value) => value is List
      ? value.whereType<Map>().map((item) {
          final map = Map<String, dynamic>.from(item);
          final page = map['pagina'];
          return BookIndexResponse(
            id: (map['id'] ?? '').toString(),
            title: (map['titulo'] ?? '').toString(),
            page: page is num ? page.toInt() : int.tryParse('$page'),
            subindexes: _indexes(map['subindices']),
          );
        }).toList()
      : const <BookIndexResponse>[];
}
