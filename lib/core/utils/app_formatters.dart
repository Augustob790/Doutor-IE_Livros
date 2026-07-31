import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppFormatters {
  AppFormatters._();

  static List<TextInputFormatter> get cpf => [
        FilteringTextInputFormatter.digitsOnly,
        CpfInputFormatter(),
      ];

  static List<TextInputFormatter> get cnpj => [
        FilteringTextInputFormatter.digitsOnly,
        CnpjInputFormatter(),
      ];

  static List<TextInputFormatter> get cpfOrCnpj => [
        FilteringTextInputFormatter.digitsOnly,
        CpfOuCnpjFormatter(),
      ];

  static List<TextInputFormatter> get telefone => [
        FilteringTextInputFormatter.digitsOnly,
        TelefoneInputFormatter(),
      ];

  static List<TextInputFormatter> get cep => [
        FilteringTextInputFormatter.digitsOnly,
        CepInputFormatter(),
      ];

  static List<TextInputFormatter> get data => [
        FilteringTextInputFormatter.digitsOnly,
        DataInputFormatter(),
      ];

  static List<TextInputFormatter> get digitsOnly => [
        FilteringTextInputFormatter.digitsOnly,
      ];

  static List<TextInputFormatter> get real => [
        ...digitsOnly,
        CentavosInputFormatter(moeda: true),
      ];

  static List<TextInputFormatter> get realNoSymbol => [
        ...digitsOnly,
        CentavosInputFormatter(moeda: false),
      ];

  static List<TextInputFormatter> get decimal => [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
      ];

  static String formatCurrency(double value) =>
      UtilBrasilFields.obterReal(value);

  static String formatCurrencyNoSymbol(double value) =>
      UtilBrasilFields.obterReal(value, moeda: false);

  static String formatCostPerKm(double value) =>
      '${UtilBrasilFields.obterReal(value)}/km';

  static String formatMonthyCost(double value) =>
      '${UtilBrasilFields.obterReal(value)}/mês';

  static String formatKm(double value) =>
      '${NumberFormat('#,##0', 'pt_BR').format(value)} km';

  static String formatKmInt(int value) =>
      '${NumberFormat('#,##0', 'pt_BR').format(value)} km';

  static String formatPercent(double value) =>
      '${value.toStringAsFixed(1).replaceAll('.', ',')}%';

  static String formatDecimal(double value, {int decimalPlaces = 2}) =>
      value.toStringAsFixed(decimalPlaces).replaceAll('.', ',');

  static String formatKmDecimal(double value, {int decimalPlaces = 1}) =>
      '${formatDecimal(value, decimalPlaces: decimalPlaces)} km';

  static String formatDate(DateTime date) =>
      DateFormat("d 'de' MMMM 'de' yyyy", 'pt_BR').format(date);

  static String formatDateShort(DateTime date) =>
      DateFormat('dd/MM/yyyy').format(date);

  static String formatDecimal4(double value) =>
      value.toStringAsFixed(4).replaceAll('.', ',');

  static String formatDecima3(double value) =>
      value.toStringAsFixed(3).replaceAll('.', ',');

  static String normalizeDecimalInput(String value) =>
      value.trim().replaceAll(',', '.');

  static String normalizeCurrencyInput(String value) {
    return value
        .trim()
        .replaceAll('R\$', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.');
  }

  static double parseDecimal(String value) {
    if (value.isEmpty) return 0.0;
    final normalized = normalizeDecimalInput(value);
    return double.tryParse(normalized) ?? 0.0;
  }

  static double? parseDecimalNullable(String value) {
    if (value.trim().isEmpty) return null;
    final normalized = normalizeDecimalInput(value);
    return double.tryParse(normalized);
  }

  static double parseCurrency(String value) {
    if (value.isEmpty) return 0.0;
    final normalized = normalizeCurrencyInput(value);
    return double.tryParse(normalized) ?? 0.0;
  }

  static double? parseCurrencyNullable(String value) {
    if (value.trim().isEmpty) return null;
    final normalized = normalizeCurrencyInput(value);
    return double.tryParse(normalized);
  }

  static String formatTime(DateTime date) =>
      DateFormat('HH:mm').format(date.toLocal());
}
