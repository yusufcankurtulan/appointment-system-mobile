import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/appointment.dart';
import '../repositories/appointments_repository.dart';

final appointmentsRepositoryProvider =
    Provider((ref) => appointmentsRepository);

final myAppointmentsProvider =
    FutureProvider.autoDispose<List<AppointmentModel>>((ref) async {
  final repo = ref.read(appointmentsRepositoryProvider);
  return repo.getMyAppointments();
});
