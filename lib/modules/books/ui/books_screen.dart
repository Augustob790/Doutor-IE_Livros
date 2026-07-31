import 'dart:async';
import 'package:doutor_ie_test/base_routes.dart';
import 'package:doutor_ie_test/core/i18n/i18n_loader.dart';
import 'package:doutor_ie_test/core/widgets/error_state.dart';
import 'package:doutor_ie_test/modules/books/books_string_keys.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book.dart';
import 'package:doutor_ie_test/modules/books/strings.dart';
import 'package:doutor_ie_test/modules/books/ui/books_store.dart';
import 'package:doutor_ie_test/modules/books/ui/books_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key, required this.viewModel, required this.store});

  final BooksViewModel viewModel;
  final BooksStore store;

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final i18N = I18nLoader(strings);
  @override
  void initState() {
    super.initState();
    unawaited(widget.viewModel.load());
  }

  Future<void> remove(Book book) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
          title: Text(i18N.getText(BooksStringKeys.deleteTitle)),
          content: Text(i18N.getTextWithParams(
              BooksStringKeys.deleteConfirmation,
              params: <String, String>{'title': book.title})),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(i18N.getText(BooksStringKeys.cancel))),
            FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(i18N.getText(BooksStringKeys.delete)))
          ]),
    );
    if (ok == true && book.id != null && mounted) {
      await widget.viewModel.delete(book.id!);
    }
  }

  Future<void> openBookForm([Book? book]) async {
    final bool? wasSaved = await context.push<bool>(
      book == null ? AppRoutesPath.bookForm : '/livros/${book.id}/editar',
      extra: book,
    );
    if (wasSaved == true && mounted) {
      await widget.viewModel.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(i18N.getText(BooksStringKeys.title))),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: openBookForm,
            icon: const Icon(Icons.add),
            label: Text(i18N.getText(BooksStringKeys.create))),
        body: ListenableBuilder(
            listenable:
                Listenable.merge(<Listenable>[widget.viewModel, widget.store]),
            builder: (context, _) {
              final vm = widget.viewModel;
              if (vm.isLoading && vm.books.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (vm.errorMessage != null && vm.books.isEmpty) {
                return ErrorState(message: vm.errorMessage!, onRetry: vm.load);
              }
              if (vm.books.isEmpty) {
                return RefreshIndicator(
                  onRefresh: vm.load,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 180),
                      const Icon(Icons.menu_book_outlined, size: 64),
                      const SizedBox(height: 16),
                      Center(child: Text(i18N.getText(BooksStringKeys.empty))),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: vm.load,
                child: LayoutBuilder(
                    builder: (context, c) => ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                c.maxWidth > 700 ? c.maxWidth * .12 : 16,
                            vertical: 20),
                        itemCount: vm.books.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final book = vm.books[index];
                          return Card(
                              child: ListTile(
                                  title: Text(book.title),
                                  subtitle: Text(i18N.getTextWithParams(
                                      BooksStringKeys.indexesCount,
                                      params: <String, String>{
                                        'count': book.indexes.length.toString()
                                      })),
                                  onTap: () => context
                                      .push('/livros/${book.id}', extra: book),
                                  trailing: Wrap(children: [
                                    IconButton(
                                        icon: const Icon(Icons.edit_outlined),
                                        onPressed: () => openBookForm(book)),
                                    IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () => remove(book))
                                  ])));
                        })),
              );
            }));
  }
}
