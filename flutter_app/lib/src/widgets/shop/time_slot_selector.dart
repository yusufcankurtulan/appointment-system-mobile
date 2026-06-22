import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

const defaultTimeSlots = [
  '09:00',
  '09:30',
  '10:00',
  '10:30',
  '11:00',
  '11:30',
  '14:00',
  '14:30',
  '15:00',
  '15:30',
];

class TimeSlotSelector extends StatelessWidget {
  final List<String> slots;
  final String? selectedSlot;
  final ValueChanged<String> onSlotSelected;

  const TimeSlotSelector({
    super.key,
    this.slots = defaultTimeSlots,
    required this.selectedSlot,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: slots.map((slot) {
        final isSelected = slot == selectedSlot;

        return GestureDetector(
          onTap: () => onSlotSelected(slot),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            child: Text(
              slot,
              style: TextStyle(
                color: isSelected ? AppColors.accentLight : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
