import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../constants/app_dimensions.dart';

class ButtonConfig {
  const ButtonConfig({
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.borderWidth = AppDimensions.borderThin,
    this.elevation = 0,
  });

  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final double borderWidth;
  final double elevation;

  static const ButtonConfig primary = ButtonConfig(
    backgroundColor: AppColors.white,
    textColor: AppColors.textPrimary,
    borderColor: AppColors.border,
    borderWidth: AppDimensions.borderThin,
    elevation: 0,
  );

  static const ButtonConfig secondary = ButtonConfig(
    backgroundColor: AppColors.primary,
    textColor: AppColors.white,
    elevation: 0,
  );

  static const ButtonConfig outlined = ButtonConfig(
    backgroundColor: AppColors.transparent,
    textColor: AppColors.primary,
    borderColor: AppColors.primary,
    borderWidth: AppDimensions.borderMedium,
    elevation: 0,
  );

  static const ButtonConfig destructive = ButtonConfig(
    backgroundColor: AppColors.error,
    textColor: AppColors.white,
    elevation: 0,
  );

  static const ButtonConfig text = ButtonConfig(
    backgroundColor: AppColors.transparent,
    textColor: AppColors.primary,
    elevation: 0,
  );

  static const ButtonConfig disabled = ButtonConfig(
    backgroundColor: AppColors.border,
    textColor: AppColors.textLight,
    elevation: 0,
  );
}
