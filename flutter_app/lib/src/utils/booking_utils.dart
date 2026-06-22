const defaultSlotDurationMinutes = 30;

DateTime parseSlotDateTime(DateTime date, String timeSlot) {
  final parts = timeSlot.split(':');
  if (parts.length != 2) {
    throw FormatException('Geçersiz saat formatı: $timeSlot');
  }

  return DateTime(
    date.year,
    date.month,
    date.day,
    int.parse(parts[0]),
    int.parse(parts[1]),
  );
}

DateTime slotEndAt(
  DateTime startAt, {
  int durationMinutes = defaultSlotDurationMinutes,
}) {
  return startAt.add(Duration(minutes: durationMinutes));
}

String formatAppointmentDate(DateTime dateTime) {
  const dayNames = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
  const monthNames = [
    'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
    'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara',
  ];

  final dayName = dayNames[dateTime.weekday - 1];
  final monthName = monthNames[dateTime.month - 1];

  return '$dayName, ${dateTime.day} $monthName';
}

String formatAppointmentTime(DateTime dateTime) {
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String appointmentStatusLabel(String status) {
  switch (status.toUpperCase()) {
    case 'PENDING':
      return 'Onay Bekliyor';
    case 'APPROVED':
      return 'Onaylandı';
    case 'REJECTED':
      return 'Reddedildi';
    default:
      return status;
  }
}
