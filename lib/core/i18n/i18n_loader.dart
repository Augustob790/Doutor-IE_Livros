/// Responsável por carregar e resolver strings traduzidas com base
/// no locale ativo. Suporta múltiplos idiomas via [Map<String, Map<String, String>>].
///
/// Uso:
/// ```dart
/// final I18nLoader _i18n = I18nLoader(strings);
/// _i18n.getText('veiculos.title'); // 'Veículos'
/// ```
class I18nLoader {
  late Map<String, Map<String, String>> localizedStrings;
  String currentLocale = 'pt';

  I18nLoader(this.localizedStrings);

  /// Retorna a string traduzida para [key] no locale atual.
  /// Utiliza o operador `?[]` para acesso seguro ao mapa.
  /// Caso não encontre, registra um aviso e retorna a própria [key].
  String getText(String key) {
    return localizedStrings[currentLocale]?[key] ?? '';
  }

  /// Igual a [getText] mas substitui parâmetros no padrão `{param}`.
  ///
  /// Exemplo: `'Olá, {name}'` com `params: {'name': 'Ana'}` → `'Olá, Ana'`
  String getTextWithParams(String key, {Map<String, String>? params}) {
    String text = getText(key);
    return _interpolateParams(text, params);
  }

  String _interpolateParams(String text, Map<String, String>? params) {
    String result = text;
    if (params != null) {
      params.forEach((key, value) {
        result = result.replaceAll('{$key}', value);
      });
    }
    return result;
  }

  /// Atalho para [getText].
  String call(String key) => getText(key);
}
