import 'package:flutter/material.dart';
import '../../constants/app_dimensions.dart';
import '../../constants/app_strings.dart';
import '../../theme/app_colors.dart';
import '../text/app_text.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.color = AppColors.primary,
    this.size = AppDimensions.spacing32,
    this.strokeWidth = AppDimensions.borderMedium,
  });

  final Color color;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: color,
      ),
    );
  }
}

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LoadingIndicator(size: AppDimensions.spacing48),
            if (message != null) ...[
              const SizedBox(height: AppDimensions.spacing16),
              AppText(
                message!,
                fontSize: AppDimensions.spacing14,
                color: AppColors.textSecondary,
              ),
            ] else ...[
              const SizedBox(height: AppDimensions.spacing16),
              AppText(
                AppStrings.loading,
                fontSize: AppDimensions.spacing14,
                color: AppColors.textSecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
