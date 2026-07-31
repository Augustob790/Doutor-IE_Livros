import 'package:doutor_ie_test/core/infra/base_api.dart';
import 'package:doutor_ie_test/core/iod.dart';
import 'package:doutor_ie_test/core/module.dart';
import 'package:doutor_ie_test/core/router.dart';
import 'package:doutor_ie_test/modules/books/books_routes.dart';
import 'package:doutor_ie_test/modules/books/domain/repositories/books_repository.dart';
import 'package:doutor_ie_test/modules/books/infra/repositories/books_repository_impl.dart';
import 'package:doutor_ie_test/modules/books/ui/book_form_viewmodel.dart';
import 'package:doutor_ie_test/modules/books/ui/books_store.dart';
import 'package:doutor_ie_test/modules/books/ui/books_viewmodel.dart';

class BooksModule extends Module {
  @override
  void initialize() {
    registerIoD();
    registerRoutes();
  }

  @override
  void registerIoD() {
    IoD.instance.registerLazySingleton<BooksRepository>(
        BooksRepositoryImpl(api: IoD.instance.get<BaseApi>()));
    IoD.instance.registerLazySingleton<BooksStore>(BooksStore());
    IoD.instance.registerFactory<BooksViewModel>(() => BooksViewModel(
        repository: IoD.instance.get(), store: IoD.instance.get()));
    IoD.instance.registerFactory<BookFormViewModel>(
        () => BookFormViewModel(repository: IoD.instance.get()));
  }

  @override
  void registerRoutes() => CoreRouter.registerRoutes(booksRoutes);
}
