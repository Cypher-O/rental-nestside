import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/text/app_text.dart';

class BookingInfoRow extends StatelessWidget {
  const BookingInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: AppDimensions.iconSmall, color: AppColors.primary),
          const SizedBox(width: AppDimensions.spacing10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                label,
                fontSize: AppTypography.fontSize10,
                color: AppColors.textSecondary,
              ),
              AppText(
                value,
                fontSize: AppTypography.fontSize14,
                fontWeight: AppTypography.weightBold,
                color: AppColors.textPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
