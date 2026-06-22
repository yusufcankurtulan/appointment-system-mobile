class UserModel {
  final String id;
  final String? firstName;
  final String email;
  final String role;

  UserModel({
    required this.id,
    required this.firstName,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id']?.toString() ?? '',
        firstName: json['firstName'] as String?,
        email: json['email'] as String? ?? '',
        role: json['role'] as String? ?? '',
      );
}