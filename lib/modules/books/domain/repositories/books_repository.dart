import 'package:doutor_ie_test/core/infra/base_response.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book_create_response.dart';

abstract class BooksRepository {
  Future<BaseResponse<List<Book>>> fetchBooks();
  Future<BaseResponse<Book>> fetchBook(String id);
  Future<BaseResponse<BookCreateResponse>> createBook(Book book);
  Future<BaseResponse<Book>> updateBook(Book book);
  Future<BaseResponse<void>> deleteBook(String id);
}
