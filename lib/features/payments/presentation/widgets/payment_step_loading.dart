import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/text/app_text.dart';

class PaymentStepLoading extends StatelessWidget {
  const PaymentStepLoading({
    super.key,
    required this.message,
    required this.subMessage,
  });

  final String message;
  final String subMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          width: AppDimensions.spacing64,
          height: AppDimensions.spacing64,
          child: CircularProgressIndicator(
            strokeWidth: AppDimensions.spacing2 + AppDimensions.spacing2 - AppDimensions.spacing2,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing28),
        AppText(
          message,
          fontSize: AppTypography.fontSize20,
          fontWeight: AppTypography.weightBold,
          color: AppColors.textPrimary,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spacing10),
        AppText(
          subMessage,
          fontSize: AppTypography.fontSize14,
          color: AppColors.textSecondary,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
