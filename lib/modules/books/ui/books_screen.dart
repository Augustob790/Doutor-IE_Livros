import 'dart:async';

import 'package:doutor_ie_test/base_routes.dart';
import 'package:doutor_ie_test/core/i18n/core_string_keys.dart';
import 'package:doutor_ie_test/core/i18n/i18n_loader.dart';
import 'package:doutor_ie_test/core/infra/login_session_storage.dart';
import 'package:doutor_ie_test/core/iod.dart';
import 'package:doutor_ie_test/core/navigator/app_navigator.dart';
import 'package:doutor_ie_test/core/utils/toast_utils.dart';
import 'package:doutor_ie_test/core/widgets/app_shell.dart';
import 'package:doutor_ie_test/core/widgets/confirmation_dialog.dart';
import 'package:doutor_ie_test/core/widgets/empty_state.dart';
import 'package:doutor_ie_test/core/widgets/error_state.dart';
import 'package:doutor_ie_test/core/widgets/responsive_content.dart';
import 'package:doutor_ie_test/modules/books/books_string_keys.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book.dart';
import 'package:doutor_ie_test/modules/books/strings.dart';
import 'package:doutor_ie_test/modules/books/store/books_store.dart';
import 'package:doutor_ie_test/modules/books/ui/books_viewmodel.dart';
import 'package:flutter/material.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({
    super.key,
    required this.viewModel,
    required this.store,
    required this.sessionStorage,
  });

  final BooksViewModel viewModel;
  final BooksStore store;
  final LoginSessionStorage sessionStorage;

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final AppNavigator _navigator = IoD.instance.get<AppNavigator>();
  final I18nLoader _i18n = I18nLoader(strings);

  @override
  void initState() {
    super.initState();
    unawaited(widget.viewModel.load());
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  Future<void> _remove(Book book) async {
    final bool confirmed = await showConfirmationDialog(
      context: context,
      title: _i18n.getText(BooksStringKeys.deleteTitle),
      message: _i18n.getTextWithParams(
        BooksStringKeys.deleteConfirmation,
        params: <String, String>{'title': book.title},
      ),
      confirmLabel: _i18n.getText(BooksStringKeys.delete),
      cancelLabel: _i18n.getText(BooksStringKeys.cancel),
      destructive: true,
    );
    if (!confirmed || book.id == null || !mounted) return;
    final bool removed = await widget.viewModel.delete(book.id!);
    if (!mounted) return;
    ToastUtils.show(
      context,
      _i18n.getText(
        removed ? BooksStringKeys.deleteSuccess : BooksStringKeys.deleteError,
      ),
      isError: !removed,
    );
  }

  Future<void> _openBookForm([Book? book]) async {
    final String route = book?.id == null ? AppRoutesPath.bookForm : AppRoutesPath.bookEditPath(book!.id!);
    final bool? wasSaved = await _navigator.push<bool>(route);
    if (wasSaved == true && mounted) await widget.viewModel.load();
  }

  void _openBook(Book book) {
    if (book.id != null) {
      _navigator.push(AppRoutesPath.bookDetailPath(book.id!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool compact = MediaQuery.sizeOf(context).width < 720;
    return AppShell(
      appTitle: _i18n.getText(CoreStringKeys.appTitle),
      appSubtitle: _i18n.getText(CoreStringKeys.appSubtitle),
      userLabel: _i18n.getText(CoreStringKeys.user),
      logoutLabel: _i18n.getText(CoreStringKeys.logout),
      onLogout: widget.sessionStorage.clear,
      floatingActionButton: compact
          ? FloatingActionButton.extended(
              onPressed: _openBookForm,
              icon: const Icon(Icons.add_rounded),
              label: Text(_i18n.getText(BooksStringKeys.create)),
            )
          : null,
      body: ListenableBuilder(
        listenable: Listenable.merge([widget.viewModel, widget.store]),
        builder: (BuildContext context, Widget? child) {
          final BooksViewModel viewModel = widget.viewModel;
          if (viewModel.isLoading && viewModel.books.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.errorMessage != null && viewModel.books.isEmpty) {
            return ErrorState(
              message: viewModel.errorMessage!,
              onRetry: viewModel.load,
            );
          }
          return RefreshIndicator(
            onRefresh: viewModel.load,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: <Widget>[
                ResponsiveContent(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildPageHeader(context, compact),
                      const SizedBox(height: 20),
                      if (viewModel.isLoading) const LinearProgressIndicator(minHeight: 2),
                      if (viewModel.books.isEmpty)
                        Card(
                          child: EmptyState(
                            title: _i18n.getText(BooksStringKeys.emptyTitle),
                            message: _i18n.getText(BooksStringKeys.emptyMessage),
                            actionLabel: _i18n.getText(BooksStringKeys.create),
                            onAction: _openBookForm,
                          ),
                        )
                      else if (compact)
                        _buildMobileList(context, viewModel.books)
                      else
                        _buildDesktopTable(context, viewModel.books),
                      const SizedBox(height: 72),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageHeader(BuildContext context, bool compact) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _i18n.getText(BooksStringKeys.title),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 6),
            Text(
              _i18n.getText(BooksStringKeys.subtitle),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        if (!compact) ...<Widget>[
          const SizedBox(width: 24),
          FilledButton.icon(
            onPressed: _openBookForm,
            icon: const Icon(Icons.add_rounded),
            label: Text(_i18n.getText(BooksStringKeys.create)),
          ),
        ],
      ],
    );
  }

  Widget _buildDesktopTable(BuildContext context, List<Book> books) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          Container(
            color: colors.surfaceContainerHighest.withValues(alpha: 0.55),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Text(_i18n.getText(BooksStringKeys.tableTitle), style: Theme.of(context).textTheme.labelLarge),
                ),
                Expanded(
                  flex: 2,
                  child:
                      Text(_i18n.getText(BooksStringKeys.tableIndexes), style: Theme.of(context).textTheme.labelLarge),
                ),
                SizedBox(
                  width: 136,
                  child: Text(
                    _i18n.getText(BooksStringKeys.tableActions),
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
          for (int index = 0; index < books.length; index++) ...<Widget>[
            if (index > 0) const Divider(height: 1),
            InkWell(
              onTap: () => _openBook(books[index]),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: colors.primaryContainer,
                            foregroundColor: colors.onPrimaryContainer,
                            child: const Icon(Icons.menu_book_rounded, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              books[index].title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(_i18n.getTextWithParams(
                        BooksStringKeys.indexesCount,
                        params: <String, String>{
                          'count': books[index].indexes.length.toString(),
                        },
                      )),
                    ),
                    SizedBox(
                      width: 136,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: _buildActions(books[index]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMobileList(BuildContext context, List<Book> books) {
    return Column(
      children: books
          .map(
            (Book book) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _openBook(book),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 8, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.menu_book_rounded, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(book.title, style: Theme.of(context).textTheme.titleMedium),
                            ),
                            const Icon(Icons.chevron_right_rounded),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(_i18n.getTextWithParams(
                          BooksStringKeys.indexesCount,
                          params: <String, String>{
                            'count': book.indexes.length.toString(),
                          },
                        )),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: _buildActions(book),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  List<Widget> _buildActions(Book book) {
    return <Widget>[
      IconButton(
        tooltip: _i18n.getText(BooksStringKeys.editTooltip),
        onPressed: () => _openBookForm(book),
        icon: const Icon(Icons.edit_outlined),
      ),
      IconButton(
        tooltip: _i18n.getText(BooksStringKeys.deleteTooltip),
        onPressed: () => _remove(book),
        icon: const Icon(Icons.delete_outline_rounded),
        color: Theme.of(context).colorScheme.error,
      ),
    ];
  }
}
