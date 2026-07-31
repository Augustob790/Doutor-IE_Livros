import 'package:doutor_ie_test/modules/books/domain/models/book.dart';
import 'package:flutter/foundation.dart';

class BooksStore extends ChangeNotifier {
  List<Book> _books = const <Book>[];

  List<Book> get books => List<Book>.unmodifiable(_books);

  Book? findById(String? id) {
    if (id == null) return null;
    for (final Book book in _books) {
      if (book.id == id) return book;
    }
    return null;
  }

  void replace(List<Book> books) {
    _books = List<Book>.unmodifiable(books);
    notifyListeners();
  }

  void removeById(String id) {
    _books = List<Book>.unmodifiable(
      _books.where((Book book) => book.id != id),
    );
    notifyListeners();
  }
}
