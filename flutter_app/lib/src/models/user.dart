class UserModel {
  final String id;
  final String? firstName;
  final String email;
  final String role;

  UserModel({required this.id, required this.firstName, required this.email, required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(id: json['id'],firstName: json['id'], email: json['email'], role: json['role']);
}
