import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/chair.dart';

class ExpertSelector extends StatelessWidget {
  final List<ChairModel> experts;
  final String? selectedExpertId;
  final ValueChanged<ChairModel> onExpertSelected;

  const ExpertSelector({
    super.key,
    required this.experts,
    required this.selectedExpertId,
    required this.onExpertSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (experts.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.cardFill,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: AppColors.cardStroke),
        ),
        child: Text(
          'Uzman bilgileri yakında eklenecek.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      );
    }

    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: experts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final expert = experts[index];
          final isSelected = expert.id == selectedExpertId;

          return _ExpertCard(
            expert: expert,
            isSelected: isSelected,
            onTap: () => onExpertSelected(expert),
          );
        },
      ),
    );
  }
}

class _ExpertCard extends StatelessWidget {
  final ChairModel expert;
  final bool isSelected;
  final VoidCallback onTap;

  const _ExpertCard({
    required this.expert,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 140,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withOpacity(0.15)
              : AppColors.cardFill,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.accent.withOpacity(0.55)
                : AppColors.cardStroke,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.accent.withOpacity(0.35),
                ),
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: AppColors.accentLight,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              expert.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              expert.bio?.trim().isNotEmpty == true
                  ? expert.bio!.trim()
                  : 'Uzman',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
