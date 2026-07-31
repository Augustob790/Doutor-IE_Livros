import 'package:doutor_ie_test/core/infra/base_response.dart';
import 'package:doutor_ie_test/core/utils/log.dart';
import 'package:doutor_ie_test/core/viewmodels/async_viewmodel.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book.dart';
import 'package:doutor_ie_test/modules/books/domain/repositories/books_repository.dart';
import 'package:doutor_ie_test/modules/books/store/books_store.dart';
import 'package:flutter/material.dart';

class BooksViewModel extends ChangeNotifier with AsyncViewModel {
  BooksViewModel({
    required BooksRepository repository,
    required BooksStore store,
  })  : _repository = repository,
        _store = store;
  final BooksRepository _repository;
  final BooksStore _store;

  final ValueNotifier<BaseResponse<List<Book>>> listBooksResponse =
      ValueNotifier<BaseResponse<List<Book>>>(BaseResponse<List<Book>>.none());

  List<Book> get books => _store.books;
  Future<void> load() async {
    if (listBooksResponse.value.isLoading) return;
    listBooksResponse.value = BaseResponse<List<Book>>.loading();
    setLoading();
    try {
      final response = await _repository.fetchBooks();
      listBooksResponse.value = response;
      if (response.isSuccess) {
        _store.replace(response.data ?? <Book>[]);
        setSuccess(notify: false);
      } else {
        setError(response.error?.message, notify: false);
      }
    } catch (error) {
      logDebug('Erro ao carregar livros: $error');
      listBooksResponse.value = BaseResponse<List<Book>>.genericError();
      setError(listBooksResponse.value.error?.message, notify: false);
    }
    notifyListeners();
  }

  Future<bool> delete(String id) async {
    setLoading();
    try {
      final response = await _repository.deleteBook(id);
      if (!response.isSuccess) {
        setError(response.error?.message);
        return false;
      }
      _store.removeById(id);
      setSuccess();
      return true;
    } catch (error) {
      logDebug('Erro ao excluir livro: $error');
      setError(BaseResponse<void>.genericError().error?.message);
      return false;
    }
  }

  @override
  void dispose() {
    listBooksResponse.dispose();
    super.dispose();
  }
}
