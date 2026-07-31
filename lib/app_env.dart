import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  static const String _apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {}
  }

  static void validate() {
    final List<String> missingRequiredKeys = <String>[];

    final String apiBaseUrl = _read('API_BASE_URL');
    if (apiBaseUrl.isEmpty) {
      missingRequiredKeys.add('API_BASE_URL');
    } else if (!_isValidBaseUrl(apiBaseUrl)) {
      throw StateError('API_BASE_URL inválida: $apiBaseUrl');
    }

    if (missingRequiredKeys.isNotEmpty) {
      throw StateError(
        'Chaves obrigatórias ausentes em --dart-define/.env: ${missingRequiredKeys.join(', ')}',
      );
    }
  }

  static String get apiBaseUrl => _readRequired('API_BASE_URL');

  static String _read(String key) {
    final String dartDefineValue =
        switch (key) { 'API_BASE_URL' => _apiBaseUrl, _ => '' };

    if (dartDefineValue.trim().isNotEmpty) {
      return dartDefineValue.trim();
    }

    return dotenv.env[key]?.trim() ?? '';
  }

  static bool _isValidBaseUrl(String value) {
    final Uri? uri = Uri.tryParse(value);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  static String _readRequired(String key) {
    final String value = _read(key);
    if (value.isEmpty) {
      throw StateError('Chave obrigatória ausente em --dart-define/.env: $key');
    }
    return value;
  }
}
