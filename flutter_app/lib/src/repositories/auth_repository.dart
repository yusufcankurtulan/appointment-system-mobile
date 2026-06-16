import '../core/api_client.dart';
import '../core/secure_storage.dart';
// (user model not used here yet)

class AuthRepository {
  final SecureStorage _storage = SecureStorage();

  Future<Map<String, dynamic>> loginCustomer(String email, String password) async {
    final resp = await dio.post('/auth/login/customer', data: {'email': email, 'password': password});
    final data = resp.data as Map<String, dynamic>;
    final access = data['accessToken'];
    final refresh = data['refreshToken'];
    await _storage.saveTokens(access: access, refresh: refresh);
    return data;
  }

  Future<Map<String, dynamic>> registerCustomer(String firstName, String lastName, String email, String phone, String password) async {
    final resp = await dio.post('/auth/register/customer', data: {'firstName': firstName, 'lastName': lastName, 'email': email, 'phone': phone, 'password': password});
    final data = resp.data as Map<String, dynamic>;
    final access = data['accessToken'];
    final refresh = data['refreshToken'];
    await _storage.saveTokens(access: access, refresh: refresh);
    return data;
  }

  Future<void> logout() async {
    final refresh = await _storage.readRefreshToken();
    if (refresh != null) {
      try {
        await dio.post('/auth/logout', data: {'token': refresh});
      } catch (_) {}
    }
    await _storage.clear();
  }

  Future<String?> getAccessToken() => _storage.readAccessToken();
}
