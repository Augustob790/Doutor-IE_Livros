class AuthMeModel {
  final String id;
  final String email;
  final String name;
  final bool emailVerified;

  const AuthMeModel({
    required this.id,
    required this.email,
    required this.name,
    required this.emailVerified,
  });

  factory AuthMeModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data =
        Map<String, dynamic>.from(json['data'] ?? json['result'] ?? json);
    final Map<String, dynamic> user =
        Map<String, dynamic>.from(data['user'] ?? data['usuario'] ?? data);
    return AuthMeModel(
      id: (user['id'] ?? user['_id'] ?? '').toString(),
      email: (user['email'] ?? '').toString(),
      name: (user['name'] ?? user['nome'] ?? '').toString(),
      emailVerified: user['emailVerified'] as bool? ??
          user['email_verified'] as bool? ??
          user['email_verified_at'] != null,
    );
  }
}
