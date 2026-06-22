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

  Future<Map<String, dynamic>> register({
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
  }) async {
    final dataPayload = <String, dynamic>{
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'password': password,
      if (shopName != null) 'shopName': shopName,
      if (shopDescription != null) 'shopDescription': shopDescription,
      if (city != null) 'city': city,
      if (district != null) 'district': district,
      if (address != null) 'address': address,
    };

    // Backend'de rol bazlı endpoint varsa burada yönlendirebilirsiniz.
    // Şimdilik genel /auth/register endpoint'i varsayıyoruz.
    final resp = await dio.post('/auth/register', data: dataPayload);
    final respData = resp.data as Map<String, dynamic>;
    final access = respData['accessToken'];
    final refresh = respData['refreshToken'];
    await _storage.saveTokens(access: access, refresh: refresh);
    return respData;
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
