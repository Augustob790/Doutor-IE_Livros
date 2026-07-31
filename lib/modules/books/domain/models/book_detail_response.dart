class BookPublisherResponse {
  const BookPublisherResponse({required this.id, required this.name});
  final String id;
  final String name;
}

class BookIndexResponse {
  const BookIndexResponse({
    required this.id,
    required this.title,
    this.page,
    this.subindexes = const <BookIndexResponse>[],
  });

  final String id;
  final String title;
  final int? page;
  final List<BookIndexResponse> subindexes;
}

class BookDetailResponse {
  const BookDetailResponse({
    required this.id,
    required this.title,
    this.publisher,
    this.indexes = const <BookIndexResponse>[],
  });

  final String id;
  final String title;
  final BookPublisherResponse? publisher;
  final List<BookIndexResponse> indexes;
}
