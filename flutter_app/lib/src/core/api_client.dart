import 'package:dio/dio.dart';

import 'auth_interceptor.dart';
import 'env.dart';
import 'secure_storage.dart';

final SecureStorage secureStorage = SecureStorage();

final Dio dio = Dio(
  BaseOptions(
    baseUrl: Env.apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json'},
  ),
);

void configureApiClient() {
  if (dio.interceptors.any((i) => i is InterceptorsWrapper)) return;
  setupAuthInterceptor(dio, secureStorage);
}
