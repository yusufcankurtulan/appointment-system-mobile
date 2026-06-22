import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/shop.dart';

class ShopCard extends StatefulWidget {
  final ShopModel shop;
  final VoidCallback? onTap;

  const ShopCard({
    super.key,
    required this.shop,
    this.onTap,
  });

  @override
  State<ShopCard> createState() => _ShopCardState();
}

class _ShopCardState extends State<ShopCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final shop = widget.shop;

    final imageUrl =
        shop.images.isNotEmpty ? shop.images.first.url : null;

    final locationText = [
      shop.district,
      shop.city,
    ].where((e) => e != null && e!.isNotEmpty).join(", ");

    return AnimatedScale(
      duration: const Duration(milliseconds: 120),
      scale: _pressed ? 0.98 : 1,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap ?? () => context.push('/shop', extra: shop),
        child: Container(
          height: 150,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          child: Row(
            children: [
              _buildImage(imageUrl, shop),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(shop),
                      const SizedBox(height: 10),
                      _buildDescription(shop),
                      const Spacer(),
                      _buildFooter(locationText, shop),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl, ShopModel shop) {
    return Hero(
      tag: 'shop-${shop.id}',
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        child: Stack(
          children: [
            Container(
              width: 120,
              height: double.infinity,
              color: const Color(0xFF111827),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return const Icon(
                          Icons.storefront_rounded,
                          color: Colors.white54,
                          size: 42,
                        );
                      },
                    )
                  : const Center(
                      child: Icon(
                        Icons.storefront_rounded,
                        color: Colors.white54,
                        size: 42,
                      ),
                    ),
            ),

            /// Gradient overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.45),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ShopModel shop) {
    return Row(
      children: [
        Expanded(
          child: Text(
            shop.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        const SizedBox(width: 8),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.green.withOpacity(0.4),
            ),
          ),
          child: const Text(
            "Açık",
            style: TextStyle(
              color: Colors.green,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(ShopModel shop) {
    final text = shop.description?.trim();

    return Text(
      text == null || text.isEmpty
          ? "Randevu oluşturmak için işletme detaylarını inceleyin."
          : text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white.withOpacity(0.65),
        height: 1.4,
        fontSize: 13,
      ),
    );
  }

  Widget _buildFooter(
    String locationText,
    ShopModel shop,
  ) {
    return Row(
      children: [
        if (locationText.isNotEmpty)
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      locationText,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        const Spacer(),

        if (shop.distanceKm != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF3B82F6).withOpacity(0.4),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.near_me_rounded,
                  size: 14,
                  color: Color(0xFF60A5FA),
                ),
                const SizedBox(width: 4),
                Text(
                  "${shop.distanceKm!.toStringAsFixed(1)} km",
                  style: const TextStyle(
                    color: Color(0xFF60A5FA),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}