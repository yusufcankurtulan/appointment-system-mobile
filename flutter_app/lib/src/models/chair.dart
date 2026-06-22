class ChairModel {
  final String id;
  final String name;
  final String? bio;

  const ChairModel({
    required this.id,
    required this.name,
    this.bio,
  });

  factory ChairModel.fromJson(Map<String, dynamic> json) {
    return ChairModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      bio: json['bio'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
    };
  }
}