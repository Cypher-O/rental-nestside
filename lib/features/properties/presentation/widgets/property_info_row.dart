import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/text/app_text.dart';

class PropertyInfoRow extends StatelessWidget {
  const PropertyInfoRow({
    super.key,
    required this.bedrooms,
    required this.bathrooms,
    required this.maxGuests,
  });

  final int bedrooms;
  final int bathrooms;
  final int maxGuests;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatChip(
          icon: Icons.bed_outlined,
          value: '$bedrooms',
          label: 'Beds',
        ),
        const SizedBox(width: AppDimensions.spacing12),
        _StatChip(
          icon: Icons.bathtub_outlined,
          value: '$bathrooms',
          label: 'Baths',
        ),
        const SizedBox(width: AppDimensions.spacing12),
        _StatChip(
          icon: Icons.group_outlined,
          value: '$maxGuests',
          label: 'Guests',
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing14,
        vertical: AppDimensions.spacing10,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppDimensions.iconSmall,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppDimensions.spacing6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                value,
                fontSize: AppTypography.fontSize15,
                fontWeight: AppTypography.weightBold,
                color: AppColors.textPrimary,
              ),
              AppText(
                label,
                fontSize: AppTypography.fontSize10,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
