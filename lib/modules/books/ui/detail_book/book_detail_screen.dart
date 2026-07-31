import 'package:doutor_ie_test/core/i18n/core_string_keys.dart';
import 'package:doutor_ie_test/core/i18n/i18n_loader.dart';
import 'package:doutor_ie_test/core/i18n/strings_pt.dart';
import 'package:doutor_ie_test/core/widgets/app_shell.dart';
import 'package:doutor_ie_test/core/widgets/responsive_content.dart';
import 'package:doutor_ie_test/modules/books/books_string_keys.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book.dart';
import 'package:doutor_ie_test/modules/books/string_pt.dart';
import 'package:flutter/material.dart';

final I18nLoader _detailI18n = I18nLoader(<String, Map<String, String>>{
  'pt': <String, String>{...stringsPt, ...booksStringsPt},
});

class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      appTitle: _detailI18n.getText(CoreStringKeys.appTitle),
      appSubtitle: _detailI18n.getText(CoreStringKeys.appSubtitle),
      onBack: () => Navigator.maybePop(context),
      body: SingleChildScrollView(
        child: ResponsiveContent(
          maxWidth: 900,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 28,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    child: const Icon(Icons.menu_book_rounded, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          book.title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _detailI18n.getTextWithParams(
                            BooksStringKeys.indexesCount,
                            params: <String, String>{
                              'count': book.indexes.length.toString(),
                            },
                          ),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        _detailI18n.getText(BooksStringKeys.indexes),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      if (book.indexes.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 36),
                          child: Column(
                            children: <Widget>[
                              const Icon(Icons.account_tree_outlined, size: 40),
                              const SizedBox(height: 10),
                              Text(
                                _detailI18n.getText(BooksStringKeys.noIndexes),
                              ),
                            ],
                          ),
                        )
                      else
                        ...book.indexes.map(
                          (BookIndex index) => _IndexNode(index: index),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IndexNode extends StatelessWidget {
  const _IndexNode({required this.index, this.depth = 0});

  final BookIndex index;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(left: depth == 0 ? 0 : 14, bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: depth == 0
              ? colors.surfaceContainerHighest.withValues(alpha: 0.45)
              : colors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  depth == 0
                      ? Icons.bookmark_outline
                      : Icons.subdirectory_arrow_right,
                  size: 19,
                  color: colors.primary,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    index.title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                if (index.page != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _detailI18n.getTextWithParams(
                        BooksStringKeys.pageValue,
                        params: <String, String>{'page': index.page.toString()},
                      ),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colors.onPrimaryContainer,
                          ),
                    ),
                  ),
              ],
            ),
            if (index.subindexes.isNotEmpty) ...<Widget>[
              const SizedBox(height: 10),
              ...index.subindexes.map(
                (BookIndex child) => _IndexNode(index: child, depth: depth + 1),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
