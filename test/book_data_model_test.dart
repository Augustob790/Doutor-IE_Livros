import 'package:doutor_ie_test/modules/books/infra/data_models/book_data_model.dart';
import 'package:doutor_ie_test/modules/books/domain/models/book.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('converte livro e subíndices do payload da API', () {
    final book = BookDataModel.fromJson({
      'id': 7,
      'titulo': 'Manual',
      'indices': [
        {
          'titulo': 'Motor',
          'pagina': 10,
          'subindices': [
            {'titulo': 'Óleo', 'pagina': '12'},
          ],
        },
      ],
    });

    expect(book.id, '7');
    expect(book.title, 'Manual');
    expect(book.indexes.single.title, 'Motor');
    expect(book.indexes.single.subindexes.single.page, 12);
  });

  test('serializa o payload completo para cadastro de livro', () {
    final json = BookDataModel.toJson(const Book(
      title: 'Livro 01',
      indexes: <BookIndex>[
        BookIndex(
          title: 'indice 1',
          page: 2,
          subindexes: <BookIndex>[
            BookIndex(
              title: 'sub-indice 1.1',
              page: 3,
              subindexes: <BookIndex>[
                BookIndex(title: 'sub-indice 1.1.1', page: 4),
              ],
            ),
            BookIndex(title: 'sub-indice 1.2', page: 5),
          ],
        ),
        BookIndex(title: 'indice 2', page: 6),
      ],
    ));

    expect(json, <String, dynamic>{
      'titulo': 'Livro 01',
      'indices': <Map<String, dynamic>>[
        <String, dynamic>{
          'titulo': 'indice 1',
          'pagina': 2,
          'subindices': <Map<String, dynamic>>[
            <String, dynamic>{
              'titulo': 'sub-indice 1.1',
              'pagina': 3,
              'subindices': <Map<String, dynamic>>[
                <String, dynamic>{
                  'titulo': 'sub-indice 1.1.1',
                  'pagina': 4,
                  'subindices': <dynamic>[],
                },
              ],
            },
            <String, dynamic>{
              'titulo': 'sub-indice 1.2',
              'pagina': 5,
              'subindices': <dynamic>[],
            },
          ],
        },
        <String, dynamic>{
          'titulo': 'indice 2',
          'pagina': 6,
          'subindices': <dynamic>[],
        },
      ],
    });
  });
}
