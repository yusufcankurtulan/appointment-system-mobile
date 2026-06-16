import 'package:flutter/material.dart';
import '../models/shop.dart';

class ShopCard extends StatelessWidget {
  final ShopModel shop;
  final VoidCallback? onTap;

  const ShopCard({super.key, required this.shop, this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = shop.images.isNotEmpty ? shop.images.first.url : null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 6)),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), bottomLeft: Radius.circular(18)),
              child: Container(
                width: 110,
                height: 110,
                color: Colors.grey[200],
                child: imageUrl != null
                    ? Image.network(imageUrl, fit: BoxFit.cover, width: 110, height: 110)
                    : const Icon(Icons.storefront, size: 48, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(shop.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.green[600], borderRadius: BorderRadius.circular(12)),
                          child: const Text('Open', style: TextStyle(color: Colors.white, fontSize: 12)),
                        )
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(shop.description ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[700])),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [const Icon(Icons.location_on, size: 14, color: Colors.grey), const SizedBox(width: 4), Text('${shop.distanceKm?.toStringAsFixed(1) ?? '-'} km', style: TextStyle(color: Colors.grey[600]))]),
                        Row(children: [const Icon(Icons.star, color: Colors.amber, size: 14), const SizedBox(width: 4), Text('4.8', style: TextStyle(color: Colors.grey[800]))]),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
