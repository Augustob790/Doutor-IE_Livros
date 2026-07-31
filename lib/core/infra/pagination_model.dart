class PaginationModel {
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  const PaginationModel({
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      total: (json['total'] ?? 0).toInt(),
      page: (json['page'] ?? 0).toInt(),
      pageSize: (json['pageSize'] ?? 0).toInt(),
      totalPages: (json['totalPages'] ?? 0).toInt(),
      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'total': total,
        'page': page,
        'pageSize': pageSize,
        'totalPages': totalPages,
        'hasNextPage': hasNextPage,
        'hasPrevPage': hasPrevPage,
      };
}
