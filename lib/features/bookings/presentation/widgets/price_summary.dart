import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/text/app_text.dart';

class PriceSummary extends StatelessWidget {
  const PriceSummary({
    super.key,
    required this.pricePerNight,
    required this.nights,
    required this.totalAmount,
  });

  final double pricePerNight;
  final int nights;
  final double totalAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(10),
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius - AppDimensions.spacing2),
        border: Border.all(color: AppColors.primary.withAlpha(40)),
      ),
      child: Column(
        children: [
          _PriceLine(
            label:
                '${CurrencyFormatter.format(pricePerNight)} \u00d7 $nights ${nights != 1 ? AppStrings.nights : AppStrings.night}',
            value: CurrencyFormatter.format(totalAmount),
          ),
          const Divider(height: AppDimensions.spacing20, color: AppColors.border),
          _PriceLine(
            label: AppStrings.totalAmount,
            value: CurrencyFormatter.format(totalAmount),
            isBold: true,
          ),
        ],
      ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  const _PriceLine({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          label,
          fontSize: isBold
              ? AppTypography.fontSize15
              : AppTypography.fontSize14,
          fontWeight: isBold
              ? AppTypography.weightBold
              : AppTypography.weightRegular,
          color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
        ),
        AppText(
          value,
          fontSize: isBold
              ? AppTypography.fontSize18
              : AppTypography.fontSize14,
          fontWeight: isBold
              ? AppTypography.weightExtraBold
              : AppTypography.weightMedium,
          color: isBold ? AppColors.primary : AppColors.textPrimary,
        ),
      ],
    );
  }
}
