import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shop.dart';
import '../repositories/shops_repository.dart';

final shopsRepositoryProvider = Provider((ref) => shopsRepository);

final nearbyShopsProvider = FutureProvider.autoDispose.family<List<ShopModel>, Map<String, double>>((ref, coords) async {
  final repo = ref.read(shopsRepositoryProvider);
  final lat = coords['lat'] ?? 0.0;
  final lng = coords['lng'] ?? 0.0;
  final radius = coords['radius'] ?? 10.0;
  final shops = await repo.getNearby(lat, lng, radius: radius);
  return shops;
});
