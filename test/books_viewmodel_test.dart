import 'package:doutor_ie_test/core/infra/base_response.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book_create_response.dart';
import 'package:doutor_ie_test/modules/books/domain/repositories/books_repository.dart';
import 'package:doutor_ie_test/modules/books/ui/books_viewmodel.dart';
import 'package:doutor_ie_test/modules/books/ui/books_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('carrega livros e transita para sucesso', () async {
    final vm = BooksViewModel(
      repository: _FakeBooksRepository(),
      store: BooksStore(),
    );

    await vm.load();

    expect(vm.isLoading, isFalse);
    expect(vm.errorMessage, isNull);
    expect(vm.books.single.title, 'Manual');
  });

  test('remove livro somente após sucesso da API', () async {
    final repository = _FakeBooksRepository();
    final vm = BooksViewModel(repository: repository, store: BooksStore());
    await vm.load();

    expect(await vm.delete('1'), isTrue);
    expect(vm.books, isEmpty);
  });
}

class _FakeBooksRepository implements BooksRepository {
  final book = const Book(id: '1', title: 'Manual');

  @override
  Future<BaseResponse<List<Book>>> fetchBooks() async =>
      BaseResponse<List<Book>>.success(data: [book], statusCode: 200);

  @override
  Future<BaseResponse<Book>> fetchBook(String id) async =>
      BaseResponse<Book>.success(data: book, statusCode: 200);

  @override
  Future<BaseResponse<BookCreateResponse>> createBook(Book value) async =>
      BaseResponse<BookCreateResponse>.success(
          data: BookCreateResponse(
              id: '1',
              publisherUserId: '24',
              title: value.title,
              createdAt: null,
              updatedAt: null),
          statusCode: 201);

  @override
  Future<BaseResponse<Book>> updateBook(Book value) async =>
      BaseResponse<Book>.success(data: value, statusCode: 200);

  @override
  Future<BaseResponse<void>> deleteBook(String id) async =>
      BaseResponse<void>.success(statusCode: 204);
}
