import 'package:doutor_ie_test/core/i18n/i18n_loader.dart';
import 'package:doutor_ie_test/core/i18n/strings_pt.dart';
import 'package:doutor_ie_test/modules/books/books_string_keys.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book.dart';
import 'package:doutor_ie_test/modules/books/string_pt.dart';
import 'package:flutter/material.dart';

final I18nLoader _i18n = I18nLoader(<String, Map<String, String>>{
  'pt': <String, String>{...stringsPt, ...booksStringsPt},
});

class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({super.key, required this.book});
  final Book book;
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Text(book.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 20),
        if (book.indexes.isEmpty)
          Text(_i18n.getText(BooksStringKeys.noIndexes))
        else
          ...book.indexes.map((index) => _IndexNode(index: index))
      ]));
}

class _IndexNode extends StatelessWidget {
  const _IndexNode({required this.index, this.depth = 0});
  final BookIndex index;
  final int depth;
  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.only(left: depth * 18.0, bottom: 8),
      child: Card(
          child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(index.title,
                        style: Theme.of(context).textTheme.titleMedium),
                    if (index.page != null)
                      Text(_i18n.getTextWithParams(
                        BooksStringKeys.pageValue,
                        params: <String, String>{'page': index.page.toString()},
                      )),
                    ...index.subindexes.map(
                        (child) => _IndexNode(index: child, depth: depth + 1))
                  ]))));
}
