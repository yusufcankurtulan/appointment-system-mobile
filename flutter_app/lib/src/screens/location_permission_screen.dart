import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/glass_container.dart';
import '../widgets/premium_background.dart';

class LocationPermissionScreen extends ConsumerStatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  ConsumerState<LocationPermissionScreen> createState() => _LocationPermissionScreenState();
}

class _LocationPermissionScreenState
    extends ConsumerState<LocationPermissionScreen> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const PremiumBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassContainer(
                  padding: const EdgeInsets.all(22),
                  borderRadius: 28,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTopIcon(),
                      const SizedBox(height: 18),
                      const Text(
                        'Yakınındaki İşletmeleri Keşfet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Sana en yakın işletmeleri gösterebilmemiz ve daha iyi bir deneyim sunabilmemiz için konum iznine ihtiyacımız var.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.65),
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF3B82F6),
                                Color(0xFF8B5CF6),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent.withOpacity(0.28),
                                blurRadius: 18,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _loading ? null : _request,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              elevation: 0,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: _loading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Konum İznini Ver',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String?> get stateExtra {
    final extra = GoRouterState.of(context).extra;
    if (extra == null) return const {};
    return (extra as Map).cast<String, String?>();
  }

  Widget _buildTopIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.92, end: 1.0),
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Icon(
            Icons.my_location_rounded,
            size: 74,
            color: AppColors.accentLight.withOpacity(0.95),
          ),
        );
      },
    );
  }

  Future<void> _request() async {
    if (_loading) return;

    setState(() => _loading = true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _loading = false);
        // Soft guidance
        await _showInfoDialog(
          title: 'Konum Servisi Kapalı',
          content:
              'Konum servisleri kapalı görünüyor. Devam edebilmek için açmalısın.',
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () async {
                await Geolocator.openLocationSettings();
                if (mounted) setState(() => _loading = false);
              },
              child: const Text('Ayarları Aç'),
            ),
          ],
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _loading = false);
        await _showDeniedForeverDialog();
        return;
      }

      if (permission == LocationPermission.denied) {
        setState(() => _loading = false);
        await _showInfoDialog(
          title: 'Konum İzni Gerekli',
          content:
              'Yakınındaki işletmeleri gösterebilmemiz için konum iznini vermen gerekiyor.',
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () async {
                await Geolocator.openAppSettings();
                if (mounted) setState(() => _loading = false);
              },
              child: const Text('Ayarları Aç'),
            ),
          ],
        );
        return;
      }

      // Granted: get current position
      await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      // Complete register with passed form data
      final firstName = stateExtra['firstName'] ?? '';
      final lastName = stateExtra['lastName'] ?? '';
      final email = stateExtra['email'] ?? '';
      final phone = stateExtra['phone'] ?? '';
      final password = stateExtra['password'] ?? '';

      final role = stateExtra['role'] ?? 'CUSTOMER';

      await ref
          .read(authProvider.notifier)
          .register(
            role: role,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
            password: password,
            shopName: stateExtra['shopName'],
            shopDescription: stateExtra['shopDescription'],
            city: stateExtra['city'],
            district: stateExtra['district'],
            address: stateExtra['address'],
          );


      if (!mounted) return;
      context.go('/home');
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Konum adımı başarısız: $e')),
      );
    }
  }

  Future<void> _showDeniedForeverDialog() async {
    await _showInfoDialog(
      title: 'Konum İzni Kalıcı Olarak Engellendi',
      content:
          'Konum izni kalıcı olarak reddedilmiş. Uygulama ayarlarından açman gerekiyor.',
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Vazgeç'),
        ),
        TextButton(
          onPressed: () async {
            await Geolocator.openAppSettings();
            if (mounted) setState(() => _loading = false);
          },
          child: const Text('Ayarları Aç'),
        ),
      ],
    );
  }

  Future<void> _showInfoDialog({
    required String title,
    required String content,
    required List<Widget> actions,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: actions,
        );
      },
    );
  }
}

