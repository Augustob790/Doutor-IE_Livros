import 'package:doutor_ie_test/core/infra/base_response.dart';
import 'package:doutor_ie_test/core/infra/login_session_storage.dart';
import 'package:doutor_ie_test/core/iod.dart';
import 'package:doutor_ie_test/core/navigator/app_navigator.dart';
import 'package:doutor_ie_test/core/theme/app_theme.dart';
import 'package:doutor_ie_test/modules/auth/domain/models/login_credentials.dart';
import 'package:doutor_ie_test/modules/auth/domain/models/login_response_model.dart';
import 'package:doutor_ie_test/modules/auth/domain/repositories/auth_repository.dart';
import 'package:doutor_ie_test/modules/auth/ui/login_screen.dart';
import 'package:doutor_ie_test/modules/auth/ui/login_viewmodel.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book_create_response.dart';
import 'package:doutor_ie_test/modules/books/domain/repositories/books_repository.dart';
import 'package:doutor_ie_test/modules/books/ui/create_book/book_form_screen.dart';
import 'package:doutor_ie_test/modules/books/ui/create_book/book_form_viewmodel.dart';
import 'package:doutor_ie_test/modules/books/ui/books_screen.dart';
import 'package:doutor_ie_test/modules/books/store/books_store.dart';
import 'package:doutor_ie_test/modules/books/ui/books_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  setUp(() async {
    await IoD.instance.reset();
    IoD.instance.registerSingleton<AppNavigator>(_FakeNavigator());
  });

  testWidgets('login alterna apresentação entre desktop e mobile', (WidgetTester tester) async {
    await _setViewport(tester, const Size(1280, 900));
    await tester.pumpWidget(_app(home: _loginScreen()));

    expect(
      find.text('Conhecimento organizado, sempre ao seu alcance.'),
      findsOneWidget,
    );
    expect(find.text('Acesse sua conta'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await _setViewport(tester, const Size(390, 844));
    await tester.pumpWidget(_app(home: _loginScreen()));

    expect(
      find.text('Conhecimento organizado, sempre ao seu alcance.'),
      findsNothing,
    );
    expect(find.text('Acesse sua conta'), findsOneWidget);
  });

  testWidgets('livros usa tabela no desktop e cartões no mobile', (WidgetTester tester) async {
    await _setViewport(tester, const Size(1280, 900));
    await tester.pumpWidget(_app(home: _booksScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Ações'), findsOneWidget);
    expect(find.text('Manual de Direito'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await _setViewport(tester, const Size(390, 844));
    await tester.pumpWidget(_app(home: _booksScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Ações'), findsNothing);
    expect(find.text('Manual de Direito'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('formulário mantém cabeçalho e ações fixos durante o scroll', (WidgetTester tester) async {
    await _setViewport(tester, const Size(390, 700));
    await tester.pumpWidget(_app(home: _bookFormScreen()));

    final Finder appTitle = find.text('Doutor-IE Livros');
    final Finder saveButton = find.text('Salvar');
    final Finder bookData = find.text('Dados do livro');
    final Offset appTitleBefore = tester.getCenter(appTitle);
    final Offset saveButtonBefore = tester.getCenter(saveButton);
    final Scaffold scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    final Finder contentScrollable = find.descendant(
      of: find.byType(SingleChildScrollView),
      matching: find.byType(Scrollable),
    );
    final ScrollableState contentScrollState = tester.stateList<ScrollableState>(contentScrollable).firstWhere(
          (ScrollableState state) => state.position.maxScrollExtent > 0,
        );

    expect(scaffold.bottomNavigationBar, isNotNull);
    expect(bookData.hitTestable(), findsOneWidget);
    expect(
      find.descendant(
        of: find.byWidget(scaffold.bottomNavigationBar!),
        matching: find.byType(SafeArea),
      ),
      findsOneWidget,
    );

    contentScrollState.position.jumpTo(
      contentScrollState.position.maxScrollExtent / 2,
    );
    await tester.pumpAndSettle();

    expect(contentScrollState.position.pixels, greaterThan(0));
    expect(tester.getCenter(appTitle), appTitleBefore);
    expect(tester.getCenter(saveButton), saveButtonBefore);
    expect(saveButtonBefore.dy, greaterThan(600));
    expect(saveButtonBefore.dy, lessThan(700));
  });
}

Widget _app({required Widget home}) => MaterialApp(
      theme: AppTheme.lightTheme,
      home: home,
    );

LoginScreen _loginScreen() => LoginScreen(
      viewModel: LoginViewModel(
        repository: _FakeAuthRepository(),
        sessionStorage: _MockSessionStorage(),
      ),
    );

BooksScreen _booksScreen() {
  final BooksStore store = BooksStore();
  return BooksScreen(
    viewModel: BooksViewModel(repository: _FakeBooksRepository(), store: store),
    store: store,
    sessionStorage: _MockSessionStorage(),
  );
}

BookFormScreen _bookFormScreen() {
  final Book book = Book(
    id: '1',
    title: 'Livro extenso',
    indexes: List<BookIndex>.generate(
      12,
      (int index) => BookIndex(
        title: 'Índice ${index + 1}',
        page: index + 1,
      ),
    ),
  );
  return BookFormScreen(
    viewModel: BookFormViewModel(
      repository: _FakeBooksRepository(),
      book: book,
    ),
  );
}

Future<void> _setViewport(WidgetTester tester, Size size) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
}

class _MockSessionStorage extends Mock implements LoginSessionStorage {}

class _FakeNavigator implements AppNavigator {
  @override
  void go(String path, {Object? extra}) {}
  @override
  void pop<T extends Object?>({T? result}) {}
  @override
  Future<T?> push<T extends Object?>(String path, {Object? extra}) async => null;
  @override
  Future<T?> pushReplacement<T extends Object?>(String path, {Object? extra}) async => null;
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<BaseResponse<LoginResponseModel>> login(
    LoginCredentials credentials,
  ) async =>
      BaseResponse<LoginResponseModel>.genericError();
}

class _FakeBooksRepository implements BooksRepository {
  static const Book book = Book(
    id: '1',
    title: 'Manual de Direito',
    indexes: <BookIndex>[BookIndex(title: 'Introdução', page: 1)],
  );

  @override
  Future<BaseResponse<List<Book>>> fetchBooks() async => BaseResponse<List<Book>>.success(
        data: const <Book>[book],
        statusCode: 200,
      );

  @override
  Future<BaseResponse<BookCreateResponse>> createBook(Book book) async =>
      BaseResponse<BookCreateResponse>.genericError();

  @override
  Future<BaseResponse<void>> deleteBook(String id) async => BaseResponse<void>.success(statusCode: 204);

  @override
  Future<BaseResponse<Book>> fetchBook(String id) async => BaseResponse<Book>.success(data: book, statusCode: 200);

  @override
  Future<BaseResponse<Book>> updateBook(Book book) async => BaseResponse<Book>.success(data: book, statusCode: 200);
}
