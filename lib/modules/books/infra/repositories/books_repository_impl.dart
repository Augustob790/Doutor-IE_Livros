import 'package:doutor_ie_test/core/infra/api_endpoints.dart';
import 'package:doutor_ie_test/core/infra/base_api.dart';
import 'package:doutor_ie_test/core/infra/base_response.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book_create_response.dart';
import 'package:doutor_ie_test/modules/books/domain/repositories/books_repository.dart';
import 'package:doutor_ie_test/modules/books/infra/data_models/book_data_model.dart';
import 'package:doutor_ie_test/modules/books/infra/data_models/book_create_response_data_model.dart';

class BooksRepositoryImpl implements BooksRepository {
  const BooksRepositoryImpl({required BaseApi api}) : _api = api;
  final BaseApi _api;
  @override
  Future<BaseResponse<List<Book>>> fetchBooks() async {
    try {
      final response = await _api.get(ApiEndpoints.books);
      if (!response.isSuccess || response.data == null) {
        return BaseResponse<List<Book>>.error(response.statusCode,
            error: response.error);
      }
      final raw = response.data!['data'] ??
          response.data!['livros'] ??
          response.data!['content'] ??
          response.data!;
      final list = raw is List ? raw : const <dynamic>[];
      return BaseResponse<List<Book>>.success(
        data: list
            .whereType<Map>()
            .map((e) => BookDataModel.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        statusCode: response.statusCode,
      );
    } catch (_) {
      return BaseResponse<List<Book>>.genericError();
    }
  }

  @override
  Future<BaseResponse<Book>> fetchBook(String id) async {
    try {
      return _readBook(await _api.get(ApiEndpoints.book(id)));
    } catch (_) {
      return BaseResponse<Book>.genericError();
    }
  }

  @override
  Future<BaseResponse<BookCreateResponse>> createBook(Book book) async {
    try {
      final response =
          await _api.post(ApiEndpoints.books, BookDataModel.toJson(book));
      if (!response.isSuccess || response.data == null) {
        return BaseResponse<BookCreateResponse>.error(response.statusCode,
            error: response.error);
      }
      return BaseResponse<BookCreateResponse>.success(
        statusCode: response.statusCode,
        data: BookCreateResponseDataModel.fromJson(response.data!),
      );
    } catch (_) {
      return BaseResponse<BookCreateResponse>.genericError();
    }
  }

  @override
  Future<BaseResponse<Book>> updateBook(Book book) async {
    try {
      return _readBook(await _api.put(
          ApiEndpoints.book(book.id!), BookDataModel.toJson(book)));
    } catch (_) {
      return BaseResponse<Book>.genericError();
    }
  }

  @override
  Future<BaseResponse<void>> deleteBook(String id) async {
    try {
      final response = await _api.delete(ApiEndpoints.book(id));
      return response.isSuccess
          ? BaseResponse<void>.success(statusCode: response.statusCode)
          : BaseResponse<void>.error(response.statusCode,
              error: response.error);
    } catch (_) {
      return BaseResponse<void>.genericError();
    }
  }

  BaseResponse<Book> _readBook(BaseResponse<Map<String, dynamic>> response) {
    if (!response.isSuccess) {
      return BaseResponse<Book>.error(response.statusCode,
          error: response.error);
    }
    final raw = response.data?['data'] ?? response.data;
    final map =
        raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
    return BaseResponse<Book>.success(
        data: BookDataModel.fromJson(map), statusCode: response.statusCode);
  }
}
