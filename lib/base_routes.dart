class AppRoutesPath {
  AppRoutesPath._();

  static const String login = '/login';
  static const String books = '/livros';
  static const String bookForm = '/livros/novo';
  static const String bookDetail = '/livros/:id';
  static const String bookEdit = '/livros/:id/editar';

  static String bookDetailPath(String id) => '/livros/$id';
  static String bookEditPath(String id) => '/livros/$id/editar';
}
