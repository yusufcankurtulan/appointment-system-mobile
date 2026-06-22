class AppointmentModel {
  final String id;
  final String customerId;
  final String chairId;
  final String shopId;
  final DateTime startAt;
  final DateTime endAt;
  final String status;
  final String? chairName;
  final String? shopName;
  final String? shopCity;
  final String? shopDistrict;

  const AppointmentModel({
    required this.id,
    required this.customerId,
    required this.chairId,
    required this.shopId,
    required this.startAt,
    required this.endAt,
    required this.status,
    this.chairName,
    this.shopName,
    this.shopCity,
    this.shopDistrict,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final chair = json['chair'] as Map<String, dynamic>?;
    final shop = json['shop'] as Map<String, dynamic>?;

    return AppointmentModel(
      id: json['id']?.toString() ?? '',
      customerId: json['customerId']?.toString() ?? '',
      chairId: json['chairId']?.toString() ?? '',
      shopId: json['shopId']?.toString() ?? '',
      startAt: DateTime.parse(json['startAt'] as String),
      endAt: DateTime.parse(json['endAt'] as String),
      status: json['status'] as String? ?? 'PENDING',
      chairName: chair?['name'] as String?,
      shopName: shop?['name'] as String?,
      shopCity: shop?['city'] as String?,
      shopDistrict: shop?['district'] as String?,
    );
  }
}

class CreateAppointmentRequest {
  final String chairId;
  final String shopId;
  final DateTime startAt;
  final DateTime endAt;

  const CreateAppointmentRequest({
    required this.chairId,
    required this.shopId,
    required this.startAt,
    required this.endAt,
  });

  Map<String, dynamic> toJson() => {
        'chairId': chairId,
        'shopId': shopId,
        'startAt': startAt.toUtc().toIso8601String(),
        'endAt': endAt.toUtc().toIso8601String(),
      };
}
