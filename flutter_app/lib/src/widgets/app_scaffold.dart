import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';

class AppScaffold extends ConsumerWidget {
  final String title;
  final Widget child;
  final bool showBack;

  const AppScaffold({
    super.key,
    required this.title,
    required this.child,
    this.showBack = false,
  });

  bool _isOwner(String role) => role.toUpperCase() == 'OWNER';

  Widget _navIcon(IconData icon, bool active) {
    return Icon(
      icon,
      size: active ? 28 : 22,
      color:
          active ? AppColors.accentLight : Colors.white.withValues(alpha: 0.72),
    );
  }

  BottomNavigationBar _buildBottomBar(
      BuildContext context, WidgetRef ref, String role) {
    final isOwner = _isOwner(role);
    final String path = GoRouterState.of(context).uri.path;

    int indexForPath() {
      if (!isOwner) {
        if (path == '/home') return 0;
        if (path == '/appointments') return 1;
        if (path == '/profile') return 2;
        return 0;
      }
      if (path == '/home') return 0;
      if (path == '/appointment-requests') return 1;
      if (path == '/profile') return 2;
      if (path == '/settings') return 3;
      return 0;
    }

    final currentIndex = indexForPath();

    final items = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: _navIcon(Icons.home_rounded, currentIndex == 0),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: _navIcon(
            isOwner
                ? Icons.notifications_active_rounded
                : Icons.event_note_rounded,
            currentIndex == 1),
        label: isOwner ? 'Talepler' : 'Randevularım',
      ),
      BottomNavigationBarItem(
        icon: _navIcon(Icons.person_rounded, currentIndex == 2),
        label: 'Profil',
      ),
      if (isOwner)
        BottomNavigationBarItem(
          icon: _navIcon(Icons.settings_rounded, currentIndex == 3),
          label: 'Ayarlar',
        ),
    ];

    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.transparent,
      elevation: 0,
      selectedItemColor: AppColors.accentLight,
      unselectedItemColor: Colors.white.withValues(alpha: 0.72),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedIconTheme: const IconThemeData(size: 28),
      unselectedIconTheme: const IconThemeData(size: 22),
      onTap: (i) {
        switch (i) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go(isOwner ? '/appointment-requests' : '/appointments');
            break;
          case 2:
            context.go('/profile');
            break;
          case 3:
            context.go('/settings');
            break;
        }
      },
      items: items,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final role = user?.role ?? 'CUSTOMER';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: child),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.24),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.22),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: _buildBottomBar(context, ref, role),
            ),
          ),
        ),
      ),
    );
  }
}
