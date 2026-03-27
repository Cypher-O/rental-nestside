import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';

class PaymentStepIcon extends StatelessWidget {
  const PaymentStepIcon({
    super.key,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    this.size = AppDimensions.iconXLarge + AppDimensions.spacing40,
    this.iconSize = AppDimensions.iconXLarge - AppDimensions.spacing4,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final double iconSize;

  factory PaymentStepIcon.success({Key? key}) => PaymentStepIcon(
        key: key,
        icon: Icons.check_circle_outline,
        backgroundColor: AppColors.successLight,
        iconColor: AppColors.success,
      );

  factory PaymentStepIcon.error({Key? key}) => PaymentStepIcon(
        key: key,
        icon: Icons.error_outline_rounded,
        backgroundColor: AppColors.errorLight,
        iconColor: AppColors.error,
      );

  factory PaymentStepIcon.awaiting({Key? key}) => PaymentStepIcon(
        key: key,
        icon: Icons.open_in_new_rounded,
        backgroundColor: AppColors.infoLight,
        iconColor: AppColors.info,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: iconSize,
      ),
    );
  }
}
