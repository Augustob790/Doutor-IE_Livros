import 'package:equatable/equatable.dart';

class Book extends Equatable {
  const Book({
    this.id,
    required this.title,
    this.indexes = const <BookIndex>[],
  });

  final String? id;
  final String title;
  final List<BookIndex> indexes;
  factory Book.fromJson(Map<String, dynamic> json) {
    final items = json['indices'] ?? json['indexes'];
    return Book(
      id: (json['id'] ?? json['_id'])?.toString(),
      title: (json['titulo'] ?? json['title'] ?? '').toString(),
      indexes: items is List
          ? items.whereType<Map>().map((item) => BookIndex.fromJson(Map<String, dynamic>.from(item))).toList()
          : const <BookIndex>[],
    );
  }
  Book copyWith({String? id, String? title, List<BookIndex>? indexes}) => Book(
        id: id ?? this.id,
        title: title ?? this.title,
        indexes: indexes ?? this.indexes,
      );

  @override
  List<Object?> get props => [id, title, indexes];
}

class BookIndex extends Equatable {
  const BookIndex({required this.title, this.page, this.subindexes = const <BookIndex>[]});
  final String title;
  final int? page;
  final List<BookIndex> subindexes;
  factory BookIndex.fromJson(Map<String, dynamic> json) {
    final value = json['pagina'] ?? json['page'];
    final items = json['subindices'] ?? json['subindexes'];
    return BookIndex(
      title: (json['titulo'] ?? json['title'] ?? '').toString(),
      page: value is num ? value.toInt() : int.tryParse('$value'),
      subindexes: items is List
          ? items.whereType<Map>().map((item) => BookIndex.fromJson(Map<String, dynamic>.from(item))).toList()
          : const <BookIndex>[],
    );
  }
  BookIndex copyWith({String? title, int? page, List<BookIndex>? subindexes}) => BookIndex(
        title: title ?? this.title,
        page: page ?? this.page,
        subindexes: subindexes ?? this.subindexes,
      );

  @override
  List<Object?> get props => [title, page, subindexes];
}
