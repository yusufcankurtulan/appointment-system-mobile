import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../providers/shops_provider.dart';
import '../widgets/shop_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Position? _position;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

static const bool kUseDemoLocation = true;

Future<void> _initLocation() async {

  // DEMO GELİŞTİRME MODU
  if (kUseDemoLocation) {
    setState(() {
      _position = Position(
        latitude: 41.0082, // Sultanahmet
        longitude: 28.9784,
        timestamp: DateTime.now(),
        accuracy: 1,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );

      _permissionDenied = false;
    });

    return;
  }

  // GERÇEK GPS AKIŞI
  final hasService = await Geolocator.isLocationServiceEnabled();

  if (!hasService) {
    setState(() => _permissionDenied = true);
    return;
  }

  var permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    setState(() => _permissionDenied = true);
    return;
  }

  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.best,
  );

  setState(() {
    _position = position;
    _permissionDenied = false;
  });
}

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    final userName =
        auth.user?.firstName?.trim().isNotEmpty == true
            ? auth.user!.firstName!
            : 'Misafir';

    return Scaffold(
      backgroundColor: const Color(0xFF060B16),
      body: Stack(
        children: [
          _buildBackground(),

          SafeArea(
            child: RefreshIndicator(
              onRefresh: _initLocation,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, userName),

                    const SizedBox(height: 24),

                    _buildSearchBar(context),

                    const SizedBox(height: 16),

                    _buildLocationCard(context),

                    const SizedBox(height: 28),

                    _buildSectionHeader(context),

                    const SizedBox(height: 12),

                    _buildNearbyContent(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildBackground() {
  return Stack(
    children: [
      Positioned(
        top: -120,
        left: -80,
        child: Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF3B82F6).withOpacity(0.18),
          ),
        ),
      ),

      Positioned(
        top: -60,
        right: -80,
        child: Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF8B5CF6).withOpacity(0.16),
          ),
        ),
      ),

      BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 120,
          sigmaY: 120,
        ),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    ],
  );
}

Widget _buildHeader(BuildContext context, String userName) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Merhaba, $userName 👋',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Bugün hangi hizmeti almak istiyorsun?',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),

        Row(
          children: [
            GestureDetector(
              onTap: () => context.push('/appointments'),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                ref.read(authProvider.notifier).logout();
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildSearchBar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        Expanded(
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
              ),
            ),
            child: const TextField(
              readOnly: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Colors.white70,
                ),
                hintText: 'İşletme veya hizmet ara',
                hintStyle: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          child: const Icon(
            Icons.tune_rounded,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

Widget _buildLocationCard(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: Color(0xFF60A5FA),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _permissionDenied
                      ? 'Konum erişimi kapalı'
                      : 'Yakınındaki işletmeler gösteriliyor',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  _permissionDenied
                      ? 'Ayarlardan konum iznini etkinleştir.'
                      : '10 km yarıçapında arama aktif',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          TextButton(
            onPressed: _permissionDenied
                ? Geolocator.openLocationSettings
                : _initLocation,
            child: Text(
              _permissionDenied ? 'Ayarlar' : 'Yenile',
              style: const TextStyle(
                color: Color(0xFF60A5FA),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildSectionHeader(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Yakındaki İşletmeler',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: 4),

        Text(
          'Bugün senin için seçtiklerimiz',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}

Widget _buildNearbyContent() {
  if (_position == null && !_permissionDenied) {
    return _buildLoadingState();
  }

  if (_permissionDenied) {
    return _buildErrorState(
      icon: Icons.location_off_rounded,
      title: 'Konum izni gerekli',
      subtitle:
          'Yakınındaki işletmeleri gösterebilmemiz için konum izni vermelisin.',
      buttonText: 'Tekrar Dene',
      onPressed: _initLocation,
    );
  }

  final shopsAsync = ref.watch(
    nearbyShopsProvider({
      'lat': _position!.latitude,
      'lng': _position!.longitude,
      'radius': 10.0,
    }),
  );

  return shopsAsync.when(
    data: (shops) {
      if (shops.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: shops.length,
        itemBuilder: (context, index) {
          final shop = shops[index];

          return ShopCard(shop: shop);
        },
      );
    },
    loading: _buildLoadingState,
    error: (error, _) {
      return _buildErrorState(
        icon: Icons.wifi_off_rounded,
        title: 'Bir sorun oluştu',
        subtitle:
            'İşletmeler yüklenirken beklenmeyen bir hata meydana geldi.',
        buttonText: 'Tekrar Dene',
        onPressed: () {
          ref.invalidate(nearbyShopsProvider);
        },
      );
    },
  );
}

Widget _buildLoadingState() {
  return Column(
    children: List.generate(
      3,
      (index) => Container(
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
            Container(
              width: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _skeletonLine(140, 18),

                    const SizedBox(height: 12),

                    _skeletonLine(double.infinity, 14),

                    const SizedBox(height: 8),

                    _skeletonLine(180, 14),

                    const Spacer(),

                    _skeletonLine(100, 28),
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

Widget _buildEmptyState() {
  return Padding(
    padding: const EdgeInsets.all(32),
    child: Column(
      children: [
        Icon(
          Icons.storefront_outlined,
          size: 72,
          color: Colors.white.withOpacity(0.5),
        ),

        const SizedBox(height: 20),

        const Text(
          'Yakınında henüz işletme bulunamadı',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          'Farklı bir konum deneyebilir veya daha sonra tekrar kontrol edebilirsin.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.65),
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}

Widget _buildErrorState({
  required IconData icon,
  required String title,
  required String subtitle,
  required String buttonText,
  required VoidCallback onPressed,
}) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 56,
            color: Colors.white70,
          ),

          const SizedBox(height: 18),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.65),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 22),

          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    ),
  );
}

Widget _skeletonLine(double width, double height) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.06),
      borderRadius: BorderRadius.circular(12),
    ),
  );
}
}