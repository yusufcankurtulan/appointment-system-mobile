import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

const _dayNames = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

class DateSelector extends StatelessWidget {
  final List<DateTime> dates;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DateSelector({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _isSameDay(date, selectedDate);

          return _DateChip(
            dayName: _dayNames[date.weekday - 1],
            dayNumber: date.day.toString(),
            isSelected: isSelected,
            onTap: () => onDateSelected(date),
          );
        },
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime? b) {
    if (b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _DateChip extends StatelessWidget {
  final String dayName;
  final String dayNumber;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateChip({
    required this.dayName,
    required this.dayNumber,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 64,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withValues(alpha: 0.18)
              : AppColors.cardFill,
          borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
          border: Border.all(
            color: isSelected
                ? AppColors.accent.withValues(alpha: 0.55)
                : AppColors.cardStroke,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: TextStyle(
                color: isSelected
                    ? AppColors.accentLight
                    : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dayNumber,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<DateTime> buildNextSevenDays({DateTime? from}) {
  final start = from ?? DateTime.now();
  final today = DateTime(start.year, start.month, start.day);

  return List.generate(7, (index) => today.add(Duration(days: index)));
}
