import 'package:doutor_ie_test/core/infra/base_response.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book_create_response.dart';
import 'package:doutor_ie_test/modules/books/domain/repositories/books_repository.dart';
import 'package:doutor_ie_test/modules/books/ui/create_book/book_form_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('cria livro quando não há livro em edição', () async {
    final repository = _FakeRepository();
    final viewModel = BookFormViewModel(repository: repository);
    final result = await viewModel.save('Manual', const <BookIndex>[]);
    expect(repository.created, isTrue);
    expect(result!.title, 'Manual');
    expect(viewModel.bookResponse.value.isSuccess, isTrue);
  });

  test('atualiza livro quando há livro em edição', () async {
    final repository = _FakeRepository();
    final viewModel = BookFormViewModel(
        repository: repository, book: const Book(id: '1', title: 'Antigo'));
    await viewModel.save('Novo', const <BookIndex>[]);
    expect(repository.updated, isTrue);
  });

  test('expõe erro e não retorna livro quando criação falha', () async {
    final repository = _FakeRepository(createSucceeds: false);
    final viewModel = BookFormViewModel(repository: repository);

    final result = await viewModel.save('Manual', const <BookIndex>[]);

    expect(result, isNull);
    expect(viewModel.errorMessage, isNotNull);
    expect(viewModel.createBookResponse.value.isSuccess, isFalse);
  });
}

class _FakeRepository implements BooksRepository {
  _FakeRepository({this.createSucceeds = true});

  final bool createSucceeds;
  bool created = false;
  bool updated = false;
  @override
  Future<BaseResponse<BookCreateResponse>> createBook(Book book) async {
    created = true;
    return createSucceeds
        ? BaseResponse<BookCreateResponse>.success(
            data: BookCreateResponse(
              id: '1',
              publisherUserId: '24',
              title: book.title,
              createdAt: null,
              updatedAt: null,
            ),
            statusCode: 201,
          )
        : BaseResponse<BookCreateResponse>.genericError();
  }

  @override
  Future<BaseResponse<Book>> updateBook(Book book) async {
    updated = true;
    return BaseResponse<Book>.success(data: book, statusCode: 200);
  }

  @override
  Future<BaseResponse<void>> deleteBook(String id) async =>
      BaseResponse<void>.success(statusCode: 204);
  @override
  Future<BaseResponse<Book>> fetchBook(String id) async =>
      BaseResponse<Book>.genericError();
  @override
  Future<BaseResponse<List<Book>>> fetchBooks() async =>
      BaseResponse<List<Book>>.success(data: const <Book>[]);
}
