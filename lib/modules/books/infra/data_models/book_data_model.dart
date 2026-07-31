import 'package:doutor_ie_test/modules/books/domain/models/book.dart';

class BookDataModel {
  const BookDataModel._();
  static Book fromJson(Map<String, dynamic> json) => Book(
        id: (json['id'] ?? json['_id'])?.toString(),
        title: (json['titulo'] ?? json['title'] ?? '').toString(),
        indexes: _list(json['indices'] ?? json['indexes'])
            .map(indexFromJson)
            .toList(),
      );
  static BookIndex indexFromJson(dynamic raw) {
    final map =
        raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
    final value = map['pagina'] ?? map['page'];
    return BookIndex(
        title: (map['titulo'] ?? map['title'] ?? '').toString(),
        page: value is num ? value.toInt() : int.tryParse('$value'),
        subindexes: _list(map['subindices'] ?? map['subindexes'])
            .map(indexFromJson)
            .toList());
  }

  static Map<String, dynamic> toJson(Book book) => <String, dynamic>{
        'titulo': book.title,
        'indices': book.indexes.map(indexToJson).toList()
      };
  static Map<String, dynamic> indexToJson(BookIndex index) => <String, dynamic>{
        'titulo': index.title,
        if (index.page != null) 'pagina': index.page,
        'subindices': index.subindexes.map(indexToJson).toList()
      };
  static List<dynamic> _list(dynamic value) =>
      value is List ? value : const <dynamic>[];
}
