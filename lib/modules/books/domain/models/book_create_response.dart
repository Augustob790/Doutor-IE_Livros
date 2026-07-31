class BookCreateResponse {
  const BookCreateResponse({
    required this.id,
    required this.publisherUserId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String publisherUserId;
  final String title;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
