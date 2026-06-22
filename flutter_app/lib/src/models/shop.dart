import 'dart:convert';
import 'chair.dart';

class ShopImageModel {
  final String id;
  final String url;
  final String? alt;

  ShopImageModel({required this.id, required this.url, this.alt});

  factory ShopImageModel.fromJson(Map<String, dynamic> json) => ShopImageModel(
        id: json['id']?.toString() ?? '',
        url: json['url'] as String? ?? '',
        alt: json['alt'] as String?,
      );
}

class ShopModel {
  final String id;
  final String name;
  final String? description;
  final String? city;
  final String? district;
  final String? address;
  final double? distanceKm;
  final List<ShopImageModel> images;
  final List<ChairModel> chairs;

  ShopModel({
    required this.id,
    required this.name,
    this.description,
    this.city,
    this.district,
    this.address,
    this.distanceKm,
    required this.images,
    required this.chairs,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) => ShopModel(
        id: json['id']?.toString() ?? '',
        name: json['name'] as String? ?? '',
        description: json['description'] as String?,
        city: json['city'] as String?,
        district: json['district'] as String?,
        address: json['address'] as String?,
        distanceKm: json['distanceKm'] != null
            ? (json['distanceKm'] as num).toDouble()
            : null,
        images: (json['images'] as List<dynamic>?)
                ?.map((e) => ShopImageModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        chairs: (json['chairs'] as List<dynamic>?)
                ?.map((e) => ChairModel.fromJson(e))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'city': city,
        'district': district,
        'address': address,
        'distanceKm': distanceKm,
        'images': images
            .map((i) => {'id': i.id, 'url': i.url, 'alt': i.alt})
            .toList(),
        'chairs': chairs.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() => jsonEncode(toJson());
}
