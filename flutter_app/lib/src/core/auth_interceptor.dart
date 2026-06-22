import 'package:dio/dio.dart';

import 'env.dart';
import 'secure_storage.dart';

const _retryKey = 'auth_retried';

void setupAuthInterceptor(Dio dio, SecureStorage storage) {
  final refreshDio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
    ),
  );

  var isRefreshing = false;
  final queue = <Future<void> Function(String? token)>[];

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storage.readAccessToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        final response = error.response;
        final requestOptions = error.requestOptions;

        if (response?.statusCode != 401 ||
            requestOptions.extra[_retryKey] == true) {
          handler.next(error);
          return;
        }

        if (isRefreshing) {
          queue.add((token) async {
            if (token == null) {
              handler.next(error);
              return;
            }
            handler.resolve(await _retryRequest(dio, requestOptions, token));
          });
          return;
        }

        isRefreshing = true;
        final newToken = await _refreshAccessToken(storage, refreshDio);
        isRefreshing = false;

        for (final callback in queue) {
          await callback(newToken);
        }
        queue.clear();

        if (newToken == null) {
          handler.next(error);
          return;
        }

        try {
          handler.resolve(await _retryRequest(dio, requestOptions, newToken));
        } catch (retryError) {
          handler.next(retryError is DioException ? retryError : error);
        }
      },
    ),
  );
}

Future<String?> _refreshAccessToken(
  SecureStorage storage,
  Dio refreshDio,
) async {
  final refreshToken = await storage.readRefreshToken();
  if (refreshToken == null || refreshToken.isEmpty) return null;

  try {
    final response = await refreshDio.post(
      '/auth/refresh',
      data: {'token': refreshToken},
    );
    final data = response.data as Map<String, dynamic>;
    final accessToken = data['accessToken'] as String?;
    if (accessToken == null || accessToken.isEmpty) return null;

    await storage.saveTokens(
      access: accessToken,
      refresh: refreshToken,
    );
    return accessToken;
  } catch (_) {
    return null;
  }
}

Future<Response<dynamic>> _retryRequest(
  Dio dio,
  RequestOptions requestOptions,
  String token,
) {
  final options = requestOptions.copyWith(
    headers: {
      ...requestOptions.headers,
      'Authorization': 'Bearer $token',
    },
    extra: {...requestOptions.extra, _retryKey: true},
  );
  return dio.fetch(options);
}
