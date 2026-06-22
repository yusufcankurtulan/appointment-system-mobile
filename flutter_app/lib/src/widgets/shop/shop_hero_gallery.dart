import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/shop.dart';

class ShopHeroGallery extends StatefulWidget {
  final ShopModel shop;
  final VoidCallback onBack;
  final VoidCallback onFavorite;

  const ShopHeroGallery({
    super.key,
    required this.shop,
    required this.onBack,
    required this.onFavorite,
  });

  @override
  State<ShopHeroGallery> createState() => _ShopHeroGalleryState();
}

class _ShopHeroGalleryState extends State<ShopHeroGallery> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.shop.images;
    final hasImages = images.isNotEmpty;

    return SizedBox(
      height: AppSpacing.heroHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'shop-${widget.shop.id}',
            child: hasImages
                ? PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      return _HeroImage(url: images[index].url);
                    },
                  )
                : const _HeroFallback(),
          ),
          const _HeroGradientOverlay(),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 8,
            left: 16,
            child: _HeroIconButton(
              icon: Icons.arrow_back_rounded,
              onTap: widget.onBack,
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 8,
            right: 16,
            child: _HeroIconButton(
              icon: Icons.favorite_border_rounded,
              onTap: widget.onFavorite,
            ),
          ),
          if (hasImages && images.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentPage == index ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.accent
                          : Colors.white.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  final String url;

  const _HeroImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.imagePlaceholder,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const _HeroFallback(),
      ),
    );
  }
}

class _HeroFallback extends StatelessWidget {
  const _HeroFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.imagePlaceholder,
      child: const Center(
        child: Icon(
          Icons.storefront_rounded,
          color: Colors.white54,
          size: 56,
        ),
      ),
    );
  }
}

class _HeroGradientOverlay extends StatelessWidget {
  const _HeroGradientOverlay();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.35),
            Colors.transparent,
            AppColors.background.withOpacity(0.85),
          ],
          stops: const [0, 0.45, 1],
        ),
      ),
    );
  }
}

class _HeroIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeroIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
