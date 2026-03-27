import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/text/app_text.dart';

class AmenityChip extends StatelessWidget {
  const AmenityChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing12,
        vertical: AppDimensions.spacing6,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(10),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: AppColors.primary.withAlpha(30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: AppDimensions.iconTiny + AppDimensions.spacing2,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppDimensions.spacing6),
          AppText(
            label,
            fontSize: AppTypography.fontSize12,
            fontWeight: AppTypography.weightMedium,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}
