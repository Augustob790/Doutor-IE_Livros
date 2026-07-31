import 'package:doutor_ie_test/modules/books/domain/models/book.dart';
import 'package:flutter/material.dart';

class Item {
  Item({String value = '', int? page, List<Item>? children})
      : value = TextEditingController(text: value),
        page = TextEditingController(text: page?.toString() ?? ''),
        children = children ?? <Item>[];

  factory Item.fromDomain(BookIndex index) => Item(
        value: index.title,
        page: index.page,
        children: index.subindexes.map(Item.fromDomain).toList(),
      );

  final TextEditingController value;
  final TextEditingController page;
  final List<Item> children;

  BookIndex toDomain() => BookIndex(
        title: value.text.trim(),
        page: int.tryParse(page.text),
        subindexes: children.map((Item item) => item.toDomain()).toList(),
      );

  void dispose() {
    value.dispose();
    page.dispose();
    for (final Item item in children) {
      item.dispose();
    }
  }
}
