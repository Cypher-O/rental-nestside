import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/text/app_text.dart';

class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacing14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: date != null ? AppColors.primary : AppColors.border,
            width: date != null
                ? AppDimensions.borderMedium
                : AppDimensions.borderThin,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              label,
              fontSize: AppTypography.fontSize12 - 1,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppDimensions.spacing4),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: AppDimensions.iconTiny + AppDimensions.spacing2,
                  color:
                      date != null ? AppColors.primary : AppColors.textLight,
                ),
                const SizedBox(width: AppDimensions.spacing6),
                AppText(
                  date != null
                      ? '${date!.day} ${_months[date!.month - 1]} ${date!.year}'
                      : 'Select date',
                  fontSize: AppTypography.fontSize13,
                  fontWeight: date != null
                      ? AppTypography.weightSemiBold
                      : AppTypography.weightRegular,
                  color:
                      date != null ? AppColors.textPrimary : AppColors.textLight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
