import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/text/app_text.dart';

class GuestCounter extends StatelessWidget {
  const GuestCounter({
    super.key,
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
    this.maxGuests,
  });

  final int value;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;
  final int? maxGuests;

  @override
  Widget build(BuildContext context) {
    final canDecrement = value > 1;
    final canIncrement = maxGuests == null || value < maxGuests!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing12,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.group_outlined,
                size: AppDimensions.iconSmall20,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppDimensions.spacing10),
              AppText(
                AppStrings.guestsLabel,
                fontSize: AppTypography.fontSize14,
                fontWeight: AppTypography.weightMedium,
                color: AppColors.textPrimary,
              ),
            ],
          ),
          Row(
            children: [
              _CounterButton(
                icon: Icons.remove,
                enabled: canDecrement,
                onTap: canDecrement ? onDecrement : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing16,
                ),
                child: AppText(
                  '$value',
                  fontSize: AppTypography.fontSize18,
                  fontWeight: AppTypography.weightBold,
                  color: AppColors.textPrimary,
                ),
              ),
              _CounterButton(
                icon: Icons.add,
                enabled: canIncrement,
                onTap: canIncrement ? onIncrement : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimensions.spacing28,
        height: AppDimensions.spacing28,
        decoration: BoxDecoration(
          color: enabled ? AppColors.primary : AppColors.border,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: AppDimensions.iconSmall,
          color: AppColors.white,
        ),
      ),
    );
  }
}
