import 'package:flutter/material.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/text/app_text.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return AppText(
      label,
      fontSize: AppTypography.fontSize16,
      fontWeight: AppTypography.weightBold,
      color: AppColors.textPrimary,
    );
  }
}
