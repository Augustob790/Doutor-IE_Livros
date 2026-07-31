import 'package:doutor_ie_test/base_routes.dart';
import 'package:doutor_ie_test/core/iod.dart';
import 'package:doutor_ie_test/core/infra/login_session_storage.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book.dart';
import 'package:doutor_ie_test/modules/books/ui/detail_book/book_detail_screen.dart';
import 'package:doutor_ie_test/modules/books/ui/create_book/book_form_screen.dart';
import 'package:doutor_ie_test/modules/books/ui/create_book/book_form_viewmodel.dart';
import 'package:doutor_ie_test/modules/books/ui/books_screen.dart';
import 'package:doutor_ie_test/modules/books/store/books_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> booksRoutes = <GoRoute>[
  GoRoute(
      path: AppRoutesPath.books,
      builder: (_, __) => BooksScreen(
            viewModel: IoD.instance.get(),
            store: IoD.instance.get<BooksStore>(),
            sessionStorage: IoD.instance.get<LoginSessionStorage>(),
          )),
  GoRoute(
      path: AppRoutesPath.bookForm,
      builder: (_, __) => BookFormScreen(viewModel: IoD.instance.get())),
  GoRoute(
      path: AppRoutesPath.bookDetail,
      builder: (_, state) {
        final Book? book =
            IoD.instance.get<BooksStore>().findById(state.pathParameters['id']);
        return book == null
            ? const _MissingBookScreen()
            : BookDetailScreen(book: book);
      }),
  GoRoute(
      path: AppRoutesPath.bookEdit,
      builder: (_, state) {
        final Book? book =
            IoD.instance.get<BooksStore>().findById(state.pathParameters['id']);
        return book == null
            ? const _MissingBookScreen()
            : BookFormScreen(
                viewModel: BookFormViewModel(
                  repository: IoD.instance.get(),
                  book: book,
                ),
              );
      }),
];

class _MissingBookScreen extends StatelessWidget {
  const _MissingBookScreen();
  @override
  Widget build(context) => BooksScreen(
        viewModel: IoD.instance.get(),
        store: IoD.instance.get<BooksStore>(),
        sessionStorage: IoD.instance.get<LoginSessionStorage>(),
      );
}
