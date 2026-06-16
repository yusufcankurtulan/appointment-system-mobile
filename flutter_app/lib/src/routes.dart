// material not required directly in this file
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';

final routerProvider = Provider((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    initialLocation: auth.user == null ? '/login' : '/home',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
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
