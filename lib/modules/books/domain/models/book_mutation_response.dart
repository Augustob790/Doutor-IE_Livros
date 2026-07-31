class BookMutationResponse {
  const BookMutationResponse({
    required this.id,
    required this.publisherUserId,
    required this.title,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String publisherUserId;
  final String title;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
}
