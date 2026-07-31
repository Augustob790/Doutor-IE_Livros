import 'package:brasil_fields/brasil_fields.dart';

class AppValidators {
  static String? requiredField(String? value,
      {String message = 'Campo obrigatório'}) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? email(
    String? value, {
    String message = 'E-mail inválido',
    String requiredMessage = 'E-mail é obrigatório',
  }) {
    if (value == null || value.trim().isEmpty) {
      return requiredMessage;
    }
    if (!value.contains('@') || !value.contains('.')) {
      return message;
    }
    return null;
  }

  static String? password(
    String? value, {
    int minLength = 6,
    String requiredMessage = 'Senha é obrigatória',
    String? minLengthMessage,
  }) {
    if (value == null || value.isEmpty) {
      return requiredMessage;
    }
    if (value.length < minLength) {
      return minLengthMessage ??
          'A senha deve ter no mínimo $minLength caracteres';
    }
    return null;
  }

  static String? strongPassword(
    String? value, {
    String requiredMessage = 'Senha é obrigatória',
    String minLengthMessage = 'A senha deve ter pelo menos 8 caracteres',
    String requirementsMessage =
        'A senha não atende aos requisitos de segurança',
  }) {
    if (value == null || value.trim().isEmpty) {
      return requiredMessage;
    }
    if (value.trim().length < 8) {
      return minLengthMessage;
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return requirementsMessage;
    }
    if (!value.contains(RegExp(r'[!@#\$&*~`^()_\-+=\[\]{}|\\:;"<>,.?/]'))) {
      return requirementsMessage;
    }
    return null;
  }

  static String? confirmPassword(String? value, String password,
      {String message = 'As senhas não coincidem'}) {
    if (value == null || value.isEmpty) {
      return 'Confirme sua senha';
    }
    if (value != password) {
      return message;
    }
    return null;
  }

  static String? cpf(String? value, {String message = 'CPF inválido'}) {
    if (value == null || value.trim().isEmpty) {
      return 'CPF é obrigatório';
    }
    if (!UtilBrasilFields.isCPFValido(value)) {
      return message;
    }
    return null;
  }

  static String? cnpj(String? value, {String message = 'CNPJ inválido'}) {
    if (value == null || value.trim().isEmpty) {
      return 'CNPJ é obrigatório';
    }
    if (!UtilBrasilFields.isCNPJValido(value)) {
      return message;
    }
    return null;
  }

  static String? cpfOrCnpj(String? value,
      {String message = 'CPF/CNPJ inválido'}) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    final String numbers = value.runes
        .where((int codeUnit) => codeUnit >= 48 && codeUnit <= 57)
        .map(String.fromCharCode)
        .join();
    if (numbers.length <= 11) {
      if (!UtilBrasilFields.isCPFValido(value)) return message;
    } else {
      if (!UtilBrasilFields.isCNPJValido(value)) return message;
    }
    return null;
  }
}
