import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;

  static ApiException fromDio(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    if (data is Map && data['message'] is String) {
      return ApiException(data['message'] as String, statusCode: statusCode);
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const ApiException('Bağlantı zaman aşımına uğradı.');
    }

    if (error.type == DioExceptionType.connectionError) {
      return const ApiException('Sunucuya bağlanılamadı.');
    }

    return ApiException(
      'Beklenmeyen bir hata oluştu.',
      statusCode: statusCode,
    );
  }
}
