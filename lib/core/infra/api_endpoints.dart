class ApiEndpoints {
  ApiEndpoints._();

  static const String login = '/auth/login';
  static const String books = '/livros';
  static String book(String id) => '$books/$id';
}
