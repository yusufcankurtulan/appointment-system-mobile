import '../core/api_client.dart';
import '../models/shop.dart';

class ShopsRepository {
  Future<List<ShopModel>> getNearby(double lat, double lng,
      {double radius = 10}) async {
    final resp = await dio.get('/shops/nearby',
        queryParameters: {'lat': lat, 'lng': lng, 'radius': radius});
    final data = resp.data as List<dynamic>;
    return data
        .map((e) => ShopModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ShopModel>> search(
      {String? city, String? district, String? name}) async {
    final params = <String, dynamic>{};
    if (city != null) params['city'] = city;
    if (district != null) params['district'] = district;
    if (name != null) params['name'] = name;
    final resp = await dio.get('/shops/search', queryParameters: params);
    final data = resp.data as List<dynamic>;
    return data
        .map((e) => ShopModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ShopModel> getById(String id) async {
    final resp = await dio.get('/shops/$id');
    return ShopModel.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<List<Map<String, dynamic>>> getChairs(String shopId) async {
    final resp = await dio.get('/shops/$shopId/chairs');
    final data = resp.data as List<dynamic>;
    return data.map((e) => e as Map<String, dynamic>).toList();
  }
}

final shopsRepository = ShopsRepository();
