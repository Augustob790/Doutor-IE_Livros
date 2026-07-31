import 'package:doutor_ie_test/core/i18n/core_string_keys.dart';
import 'package:doutor_ie_test/core/i18n/i18n_loader.dart';
import 'package:doutor_ie_test/core/iod.dart';
import 'package:doutor_ie_test/core/navigator/app_navigator.dart';
import 'package:doutor_ie_test/core/utils/app_validators.dart';
import 'package:doutor_ie_test/core/utils/toast_utils.dart';
import 'package:doutor_ie_test/core/widgets/app_shell.dart';
import 'package:doutor_ie_test/core/widgets/responsive_content.dart';
import 'package:doutor_ie_test/modules/books/books_string_keys.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book.dart';
import 'package:doutor_ie_test/modules/books/domain/models/item.dart';
import 'package:doutor_ie_test/modules/books/strings.dart';
import 'package:doutor_ie_test/modules/books/ui/create_book/book_form_viewmodel.dart';
import 'package:doutor_ie_test/modules/books/ui/create_book/widgets/item_widget_editor.dart';
import 'package:flutter/material.dart';

class BookFormScreen extends StatefulWidget {
  const BookFormScreen({super.key, required this.viewModel});

  final BookFormViewModel viewModel;

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AppNavigator _navigator = IoD.instance.get<AppNavigator>();

  late final TextEditingController _titleController;
  late final List<Item> _items;
  final I18nLoader _i18n = I18nLoader(strings);

  @override
  void initState() {
    super.initState();
    final Book? book = widget.viewModel.book;
    _titleController = TextEditingController(text: book?.title);
    _titleController.addListener(() => setState(() {}));
    _items = (book?.indexes ?? <BookIndex>[]).map(Item.fromDomain).toList();
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final Item item in _items) {
      item.dispose();
    }
    widget.viewModel.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    if (_titleController.text.trim().isEmpty) return false;
    if (_items.isEmpty) return false;
    return _items.every(_isItemValid);
  }

  bool _isItemValid(Item item) {
    if (item.value.text.trim().isEmpty) return false;
    if (item.page.text.trim().isEmpty) return false;
    return item.children.every(_isItemValid);
  }

  Future<void> _save() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final Book? result = await widget.viewModel.save(
      _titleController.text.trim(),
      _items.map((Item item) => item.toDomain()).toList(),
    );
    if (!mounted) return;
    if (result == null) {
      ToastUtils.show(
        context,
        widget.viewModel.errorMessage ??
            _i18n.getText(BooksStringKeys.saveError),
        isError: true,
      );
      return;
    }
    _navigator.pop(result: true);
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      appTitle: _i18n.getText(CoreStringKeys.appTitle),
      appSubtitle: _i18n.getText(CoreStringKeys.appSubtitle),
      onBack: () => _navigator.pop(),
      bottomBar: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (BuildContext context, Widget? child) =>
            _buildBottomActions(context),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (BuildContext context, Widget? child) {
          return SingleChildScrollView(
            child: ResponsiveContent(
              maxWidth: 1120,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      _i18n.getText(BooksStringKeys.formTitle),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _i18n.getText(BooksStringKeys.formSubtitle),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 24),
                    LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        final bool expanded =
                            constraints.maxWidth >= AppBreakpoints.expanded;
                        final Widget titleSection = _buildTitleSection(context);
                        final Widget indexesSection =
                            _buildIndexesSection(context);
                        if (!expanded) {
                          return Column(
                            children: <Widget>[
                              titleSection,
                              const SizedBox(height: 16),
                              indexesSection,
                            ],
                          );
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width: 300, child: titleSection),
                            const SizedBox(width: 20),
                            Expanded(child: indexesSection),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant)),
      ),
      child: Align(
        alignment: Alignment.center,
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final bool compact =
                    constraints.maxWidth < AppBreakpoints.compact;
                final Widget cancelButton = OutlinedButton(
                  onPressed: widget.viewModel.isLoading
                      ? null
                      : () => _navigator.pop(),
                  child: Text(_i18n.getText(BooksStringKeys.cancel)),
                );
                
                final bool canSave = _isFormValid && !widget.viewModel.isLoading;
                
                final Widget saveButton = FilledButton.icon(
                  onPressed: canSave ? _save : null,
                  icon: widget.viewModel.isLoading
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_rounded),
                  label: Text(
                    _i18n.getText(
                      widget.viewModel.isLoading
                          ? BooksStringKeys.saving
                          : BooksStringKeys.save,
                    ),
                  ),
                );
                if (compact) {
                  return Row(
                    children: <Widget>[
                      Expanded(child: cancelButton),
                      const SizedBox(width: 12),
                      Expanded(child: saveButton),
                    ],
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(width: 160, child: cancelButton),
                    const SizedBox(width: 12),
                    SizedBox(width: 160, child: saveButton),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              _i18n.getText(BooksStringKeys.bookData),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              enabled: !widget.viewModel.isLoading,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: _i18n.getText(BooksStringKeys.tableTitle),
                prefixIcon: const Icon(Icons.menu_book_outlined),
              ),
              validator: (String? value) => AppValidators.requiredField(
                value,
                message: _i18n.getText(BooksStringKeys.requiredTitle),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndexesSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    _i18n.getText(BooksStringKeys.indexes),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: widget.viewModel.isLoading
                      ? null
                      : () => setState(() => _items.add(Item())),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(_i18n.getText(BooksStringKeys.add)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _i18n.getText(BooksStringKeys.indexesHint),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            if (_items.isEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: <Widget>[
                    const Icon(Icons.account_tree_outlined, size: 36),
                    const SizedBox(height: 10),
                    Text(
                      _i18n.getText(BooksStringKeys.noIndexes),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ..._items.asMap().entries.map(
                    (MapEntry<int, Item> entry) => ItemWidgetEditor(
                      item: entry.value,
                      onChanged: () => setState(() {}),
                      onDelete: () => setState(() {
                        entry.value.dispose();
                        _items.removeAt(entry.key);
                      }),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
