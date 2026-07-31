import 'package:doutor_ie_test/core/i18n/i18n_loader.dart';
import 'package:doutor_ie_test/core/i18n/strings_pt.dart';
import 'package:doutor_ie_test/core/utils/app_validators.dart';
import 'package:doutor_ie_test/modules/books/books_string_keys.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book.dart';
import 'package:doutor_ie_test/modules/books/string_pt.dart';
import 'package:doutor_ie_test/modules/books/ui/book_form_viewmodel.dart';
import 'package:flutter/material.dart';

final I18nLoader _i18n = I18nLoader(<String, Map<String, String>>{
  'pt': <String, String>{...stringsPt, ...booksStringsPt},
});

class BookFormScreen extends StatefulWidget {
  const BookFormScreen({super.key, required this.viewModel});

  final BookFormViewModel viewModel;

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final form = GlobalKey<FormState>();
  late TextEditingController title;
  late List<_Item> items;
  @override
  void initState() {
    super.initState();
    final book = widget.viewModel.book;
    title = TextEditingController(text: book?.title);
    items = (book?.indexes ?? []).map(_Item.fromDomain).toList();
  }

  @override
  void dispose() {
    title.dispose();
    for (final item in items) {
      item.dispose();
    }
    super.dispose();
  }

  Future<void> save() async {
    if (!form.currentState!.validate()) return;
    final value = await widget.viewModel
        .save(title.text, items.map((x) => x.toDomain()).toList());
    if (value != null && mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(_i18n.getText(BooksStringKeys.formTitle))),
      body: Center(
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: Form(
                  key: form,
                  child: ListView(padding: const EdgeInsets.all(24), children: [
                    TextFormField(
                        controller: title,
                        decoration: InputDecoration(
                            labelText:
                                _i18n.getText(BooksStringKeys.formTitle)),
                        validator: (value) => AppValidators.requiredField(value,
                            message:
                                _i18n.getText(BooksStringKeys.requiredTitle))),
                    const SizedBox(height: 24),
                    Row(children: [
                      Text(_i18n.getText(BooksStringKeys.indexes),
                          style: Theme.of(context).textTheme.titleLarge),
                      const Spacer(),
                      TextButton.icon(
                          onPressed: () => setState(() => items.add(_Item())),
                          icon: const Icon(Icons.add),
                          label: Text(_i18n.getText(BooksStringKeys.add)))
                    ]),
                    ...items.asMap().entries.map((e) => _ItemEditor(
                        item: e.value,
                        onChanged: () => setState(() {}),
                        onDelete: () => setState(() {
                              e.value.dispose();
                              items.removeAt(e.key);
                            }))),
                    ListenableBuilder(
                        listenable: widget.viewModel,
                        builder: (_, __) => ElevatedButton(
                            onPressed: widget.viewModel.isLoading ? null : save,
                            child: Text(widget.viewModel.isLoading
                                ? _i18n.getText(BooksStringKeys.saving)
                                : _i18n.getText(BooksStringKeys.save))))
                  ])))));
}

class _Item {
  _Item({String value = '', int? page, List<_Item>? children})
      : value = TextEditingController(text: value),
        page = TextEditingController(text: page?.toString() ?? ''),
        children = children ?? [];
  factory _Item.fromDomain(BookIndex x) => _Item(
      value: x.title,
      page: x.page,
      children: x.subindexes.map(_Item.fromDomain).toList());
  final TextEditingController value, page;
  final List<_Item> children;
  BookIndex toDomain() => BookIndex(
      title: value.text,
      page: int.tryParse(page.text),
      subindexes: children.map((x) => x.toDomain()).toList());
  void dispose() {
    value.dispose();
    page.dispose();
    for (final x in children) {
      x.dispose();
    }
  }
}

class _ItemEditor extends StatelessWidget {
  const _ItemEditor(
      {required this.item,
      required this.onChanged,
      required this.onDelete,
      this.depth = 0});
  final _Item item;
  final VoidCallback onChanged, onDelete;
  final int depth;
  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.only(left: depth * 16.0, top: 8),
      child: Card(
          child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(children: [
                Row(children: [
                  Expanded(
                      child: TextField(
                          controller: item.value,
                          decoration: InputDecoration(
                              labelText: _i18n
                                  .getText(BooksStringKeys.indexOrSubindex)),
                          onChanged: (_) => onChanged())),
                  const SizedBox(width: 8),
                  SizedBox(
                      width: 90,
                      child: TextField(
                          controller: item.page,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: _i18n.getText(BooksStringKeys.page)),
                          onChanged: (_) => onChanged())),
                  IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline))
                ]),
                Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                        onPressed: () {
                          item.children.add(_Item());
                          onChanged();
                        },
                        icon: const Icon(Icons.add),
                        label: Text(_i18n.getText(BooksStringKeys.subindex)))),
                ...item.children.asMap().entries.map((e) => _ItemEditor(
                    item: e.value,
                    depth: depth + 1,
                    onChanged: onChanged,
                    onDelete: () {
                      e.value.dispose();
                      item.children.removeAt(e.key);
                      onChanged();
                    }))
              ]))));
}
