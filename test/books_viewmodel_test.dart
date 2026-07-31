import 'package:doutor_ie_test/core/infra/base_response.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book_create_response.dart';
import 'package:doutor_ie_test/modules/books/domain/repositories/books_repository.dart';
import 'package:doutor_ie_test/modules/books/ui/books_viewmodel.dart';
import 'package:doutor_ie_test/modules/books/store/books_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('store localiza livro por id sem expor lista mutável', () {
    final BooksStore store = BooksStore();
    store.replace(const <Book>[Book(id: '1', title: 'Manual')]);

    expect(store.findById('1')?.title, 'Manual');
    expect(store.findById('inexistente'), isNull);
    expect(() => store.books.add(const Book(title: 'Outro')),
        throwsUnsupportedError);
  });

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

  test('preserva livros e expõe erro quando exclusão falha', () async {
    final repository = _FakeBooksRepository(deleteSucceeds: false);
    final vm = BooksViewModel(repository: repository, store: BooksStore());
    await vm.load();

    expect(await vm.delete('1'), isFalse);
    expect(vm.books.single.id, '1');
    expect(vm.errorMessage, isNotNull);
  });

  test('expõe erro quando carregamento falha', () async {
    final vm = BooksViewModel(
      repository: _FakeBooksRepository(loadSucceeds: false),
      store: BooksStore(),
    );

    await vm.load();

    expect(vm.books, isEmpty);
    expect(vm.errorMessage, isNotNull);
    expect(vm.listBooksResponse.value.isSuccess, isFalse);
  });
}

class _FakeBooksRepository implements BooksRepository {
  _FakeBooksRepository({this.loadSucceeds = true, this.deleteSucceeds = true});

  final bool loadSucceeds;
  final bool deleteSucceeds;
  final book = const Book(id: '1', title: 'Manual');

  @override
  Future<BaseResponse<List<Book>>> fetchBooks() async => loadSucceeds
      ? BaseResponse<List<Book>>.success(data: [book], statusCode: 200)
      : BaseResponse<List<Book>>.genericError();

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
  Future<BaseResponse<void>> deleteBook(String id) async => deleteSucceeds
      ? BaseResponse<void>.success(statusCode: 204)
      : BaseResponse<void>.genericError();
}
