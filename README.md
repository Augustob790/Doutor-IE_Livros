# Doutor-IE Livros

Aplicação Flutter responsiva para gestão de livros e índices, preparada para
Android, iOS, desktop e navegador.

## Execução

Configure `API_BASE_URL` no arquivo `.env` ou por `--dart-define` e execute:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=https://api.exemplo.com
```

Para gerar a versão web:

```bash
flutter build web --release --dart-define=API_BASE_URL=https://api.exemplo.com
```

O mesmo código adapta a navegação e os componentes para telas compactas e
expandidas.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
