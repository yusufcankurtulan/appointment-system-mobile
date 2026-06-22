// material not required directly in this file
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/shop_detail_screen.dart';
import 'screens/appointments_screen.dart';
import 'screens/location_permission_screen.dart';
import 'widgets/app_scaffold.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/owner_appointment_requests_screen.dart';
import 'models/shop.dart';

final routerProvider = Provider((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    initialLocation: auth.user == null ? '/login' : '/home',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen()),
      GoRoute(
        path: '/location-permission',
        builder: (context, state) => const LocationPermissionScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) =>
            const AppScaffold(title: 'Home', child: HomeScreen()),
      ),
      GoRoute(
        path: '/shop',
        builder: (context, state) {
          final shop = state.extra as ShopModel;
          return ShopDetailScreen(shop: shop);
        },
      ),
      GoRoute(
        path: '/appointments',
        builder: (context, state) => const AppScaffold(
            title: 'Randevularım', child: AppointmentsScreen()),
      ),
      GoRoute(
        path: '/appointment-requests',
        builder: (context, state) => const AppScaffold(
          title: 'Randevu Talepleri',
          child: OwnerAppointmentRequestsScreen(),
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) =>
            const AppScaffold(title: 'Profil', child: ProfileScreen()),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) =>
            const AppScaffold(title: 'Ayarlar', child: SettingsScreen()),
      ),
    ],
    redirect: (context, state) {
      final loggedIn = auth.user != null;
      // use URI path to determine current location across go_router versions
      final path = state.uri.path;
      final loggingIn = path == '/login' || path == '/register';
      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && loggingIn) return '/home';
      return null;
    },
  );
});
