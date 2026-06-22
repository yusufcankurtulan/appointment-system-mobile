import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class QuickInfoChips extends StatelessWidget {
  final int expertCount;

  const QuickInfoChips({
    super.key,
    required this.expertCount,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _InfoChip(
          icon: Icons.circle,
          iconColor: AppColors.open,
          label: 'Açık',
          accent: true,
          accentColor: AppColors.open,
        ),
        const _InfoChip(
          icon: Icons.schedule_rounded,
          label: 'Yaklaşık 30 dk',
        ),
        _InfoChip(
          icon: Icons.people_outline_rounded,
          label: expertCount > 0 ? '$expertCount uzman' : 'Uzman bilgisi yok',
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final bool accent;
  final Color? accentColor;

  const _InfoChip({
    required this.icon,
    required this.label,
    this.iconColor,
    this.accent = false,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.accent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: accent ? color.withValues(alpha: 0.15) : AppColors.cardFill,
        borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
        border: Border.all(
          color: accent ? color.withValues(alpha: 0.4) : AppColors.cardStroke,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: accent ? 10 : 16,
            color: iconColor ?? (accent ? color : Colors.white70),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: accent ? color : Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
