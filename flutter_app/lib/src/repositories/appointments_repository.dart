import 'package:dio/dio.dart';

import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../models/appointment.dart';

class AppointmentsRepository {
  Future<AppointmentModel> requestAppointment(
    CreateAppointmentRequest request,
  ) async {
    try {
      final response = await dio.post(
        '/appointments/request',
        data: request.toJson(),
      );
      return AppointmentModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<List<AppointmentModel>> getMyAppointments() async {
    try {
      final response = await dio.get('/appointments');
      final data = response.data as List<dynamic>;
      return data
          .map(
              (item) => AppointmentModel.fromJson(item as Map<String, dynamic>))
          .toList(growable: false);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}

final appointmentsRepository = AppointmentsRepository();
