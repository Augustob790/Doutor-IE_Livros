import 'package:doutor_ie_test/core/infra/base_response.dart';
import 'package:doutor_ie_test/core/utils/log.dart';
import 'package:doutor_ie_test/core/viewmodels/async_viewmodel.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book_create_response.dart';
import 'package:doutor_ie_test/modules/books/domain/repositories/books_repository.dart';
import 'package:flutter/material.dart';

class BookFormViewModel extends ChangeNotifier with AsyncViewModel {
  BookFormViewModel({required BooksRepository repository, this.book})
      : _repository = repository;

  final BooksRepository _repository;
  final Book? book;
  final ValueNotifier<BaseResponse<Book>> bookResponse =
      ValueNotifier<BaseResponse<Book>>(BaseResponse<Book>.none());
  final ValueNotifier<BaseResponse<BookCreateResponse>> createBookResponse =
      ValueNotifier<BaseResponse<BookCreateResponse>>(
          BaseResponse<BookCreateResponse>.none());

  Future<Book?> save(String title, List<BookIndex> indexes) async {
    final draft = Book(id: book?.id, title: title, indexes: indexes);
    setLoading();
    try {
      if (book == null) {
        final response = await _repository.createBook(draft);
        createBookResponse.value = response;
        if (!response.isSuccess || response.data == null) {
          setError(response.error?.message);
          return null;
        }
        final result = Book(id: response.data!.id, title: response.data!.title);
        bookResponse.value = BaseResponse<Book>.success(
            data: result, statusCode: response.statusCode);
        setSuccess();
        return result;
      }
      final response = await _repository.updateBook(draft);
      bookResponse.value = response;
      if (!response.isSuccess) {
        setError(response.error?.message);
        return null;
      }
      setSuccess();
      return response.data;
    } catch (error) {
      logDebug('Erro ao salvar livro: $error');
      bookResponse.value = BaseResponse<Book>.genericError();
      setError(bookResponse.value.error?.message);
      return null;
    }
  }

  @override
  void dispose() {
    bookResponse.dispose();
    createBookResponse.dispose();
    super.dispose();
  }
}
