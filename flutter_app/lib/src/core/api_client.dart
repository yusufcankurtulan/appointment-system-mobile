import 'package:dio/dio.dart';
import 'env.dart';

// Minimal API client for the app. Interceptors removed temporarily.
final Dio dio = Dio(
	BaseOptions(
		baseUrl: Env.apiBaseUrl,
		connectTimeout: const Duration(seconds: 10),
	),
);
