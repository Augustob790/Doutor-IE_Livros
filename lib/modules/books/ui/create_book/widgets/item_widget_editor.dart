import 'package:doutor_ie_test/core/i18n/i18n_loader.dart';
import 'package:doutor_ie_test/core/utils/app_validators.dart';
import 'package:doutor_ie_test/modules/books/books_string_keys.dart';
import 'package:doutor_ie_test/modules/books/domain/models/item.dart';
import 'package:doutor_ie_test/modules/books/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ItemWidgetEditor extends StatelessWidget {
  const ItemWidgetEditor({
    super.key,
    required this.item,
    required this.onChanged,
    required this.onDelete,
    this.depth = 0,
  });

  final Item item;
  final VoidCallback onChanged;
  final VoidCallback onDelete;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final I18nLoader i18N = I18nLoader(strings);

    final ColorScheme colors = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(left: depth == 0 ? 0 : 12, bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: depth == 0
              ? colors.surfaceContainerHighest.withValues(alpha: 0.38)
              : colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final Widget nameField = TextFormField(
                    controller: item.value,
                    decoration: InputDecoration(
                      labelText: i18N.getText(
                        depth == 0
                            ? BooksStringKeys.index
                            : BooksStringKeys.subindex,
                      ),
                    ),
                    validator: (String? value) => AppValidators.requiredField(
                      value,
                      message: i18N.getText(BooksStringKeys.requiredIndex),
                    ),
                    onChanged: (_) => onChanged(),
                  );
                  final Widget pageField = TextFormField(
                    controller: item.page,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                        labelText: i18N.getText(BooksStringKeys.page)),
                    onChanged: (_) => onChanged(),
                  );
                  final Widget deleteButton = IconButton(
                    tooltip: i18N.getText(BooksStringKeys.deleteTooltip),
                    onPressed: onDelete,
                    color: colors.error,
                    icon: const Icon(Icons.delete_outline_rounded),
                  );
                  if (constraints.maxWidth < 500) {
                    return Column(
                      children: <Widget>[
                        nameField,
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Expanded(child: pageField),
                            deleteButton,
                          ],
                        ),
                      ],
                    );
                  }
                  return Row(
                    children: <Widget>[
                      Expanded(child: nameField),
                      const SizedBox(width: 10),
                      SizedBox(width: 112, child: pageField),
                      deleteButton,
                    ],
                  );
                },
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    item.children.add(Item());
                    onChanged();
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: Text(i18N.getText(BooksStringKeys.subindex)),
                ),
              ),
              ...item.children.asMap().entries.map(
                    (MapEntry<int, Item> entry) => ItemWidgetEditor(
                      item: entry.value,
                      depth: depth + 1,
                      onChanged: onChanged,
                      onDelete: () {
                        entry.value.dispose();
                        item.children.removeAt(entry.key);
                        onChanged();
                      },
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
