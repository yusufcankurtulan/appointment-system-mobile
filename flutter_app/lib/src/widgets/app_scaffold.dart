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

  BottomNavigationBar _buildBottomBar(BuildContext context, WidgetRef ref, String role) {
    final isOwner = _isOwner(role);

    final items = <BottomNavigationBarItem>[
      if (!isOwner)
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
      if (isOwner)
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
        ),

      if (!isOwner)
        const BottomNavigationBarItem(
          icon: Icon(Icons.event_note_rounded),
          label: 'Randevularım',
        ),

      if (isOwner)
        const BottomNavigationBarItem(
          icon: Icon(Icons.notifications_active_rounded),
          label: 'Randevu Talepleri',
        ),

      const BottomNavigationBarItem(
        icon: Icon(Icons.person_rounded),
        label: 'Profil',
      ),

      if (isOwner)
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings_rounded),
          label: 'Ayarlar',
        ),
    ];

    final String path = GoRouterState.of(context).uri.path;

    int indexForPath() {
      if (!isOwner) {
        if (path == '/home') return 0;
        if (path == '/appointments') return 1;
        if (path == '/profile') return 2;
        return 0;
      }

      // owner
      if (path == '/home') return 0;
      if (path == '/appointment-requests') return 1;
      if (path == '/profile') return 2;
      if (path == '/settings') return 3;
      return 0;
    }

    final currentIndex = indexForPath();

    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.transparent,
      elevation: 0,
      selectedItemColor: AppColors.accentLight,
      unselectedItemColor: Colors.white.withOpacity(0.7),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (i) {
        switch (i) {
          case 0:
            context.go('/home');
            break;
          case 1:
            if (isOwner) {
              context.go('/appointment-requests');
            } else {
              context.go('/appointments');
            }
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
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
            ),
            padding: const EdgeInsets.only(top: 6, bottom: 10),
            child: _buildBottomBar(context, ref, role),
          ),
        ),
      ),
    );
  }
}

