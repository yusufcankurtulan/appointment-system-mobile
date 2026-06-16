import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

class AuthState {
  final UserModel? user;
  final bool loading;

  AuthState({this.user, this.loading = false});

  AuthState copyWith({UserModel? user, bool? loading}) => AuthState(user: user ?? this.user, loading: loading ?? this.loading);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  AuthNotifier(this._repo) : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true);
    try {
      final data = await _repo.loginCustomer(email, password);
      final user = UserModel.fromJson(data['user']);
      state = state.copyWith(user: user, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false);
      rethrow;
    }
  }

  Future<void> register(String firstName, String lastName, String email, String phone, String password) async {
    state = state.copyWith(loading: true);
    try {
      final data = await _repo.registerCustomer(firstName, lastName, email, phone, password);
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
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier(ref.read(authRepositoryProvider)));
