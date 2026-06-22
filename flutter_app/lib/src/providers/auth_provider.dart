import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

class AuthState {
  final UserModel? user;
  final bool loading;

  AuthState({this.user, this.loading = false});

  AuthState copyWith({UserModel? user, bool? loading}) =>
      AuthState(user: user ?? this.user, loading: loading ?? this.loading);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  AuthNotifier(this._repo) : super(AuthState());

  Future<void> login(String email, String password) async {
    print('[AuthProvider] Starting login for: $email');
    state = state.copyWith(loading: true);
    try {
      final data = await _repo.loginCustomer(email, password);
      print('[AuthProvider] Got response, extracting user');
      print('[AuthProvider] Data keys: ${data.keys}');
      final user = UserModel.fromJson(data['user']);
      print('[AuthProvider] User created: ${user.id}');
      state = state.copyWith(user: user, loading: false);
      print('[AuthProvider] State updated, login complete');
    } catch (e) {
      print('[AuthProvider] Login error: $e');
      state = state.copyWith(loading: false);
      rethrow;
    }
  }

  Future<void> register({
    required String role,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    String? shopName,
    String? shopDescription,
    String? city,
    String? district,
    String? address,
    String? shopPhone,
  }) async {
    state = state.copyWith(loading: true);
    try {
      final data = await _repo.register(
        role: role,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        password: password,
        shopName: shopName,
        shopDescription: shopDescription,
        city: city,
        district: district,
        address: address,
        shopPhone: shopPhone,
      );
      final user = UserModel.fromJson(data['user']);
      state = state.copyWith(user: user, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false);
      rethrow;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = AuthState();
  }
}

final authRepositoryProvider = Provider((ref) => AuthRepository());
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
    (ref) => AuthNotifier(ref.read(authRepositoryProvider)));
