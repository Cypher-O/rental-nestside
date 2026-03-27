import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/text/app_text.dart';

class RoleSelector extends StatelessWidget {
  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
  });

  final String selectedRole;
  final ValueChanged<String> onRoleChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          AppStrings.role,
          fontSize: AppTypography.fontSize14,
          fontWeight: AppTypography.weightSemiBold,
          color: AppColors.textPrimary,
        ),
        const SizedBox(height: AppDimensions.spacing10),
        Row(
          children: [
            Expanded(
              child: _RoleChip(
                label: AppStrings.tenant,
                icon: Icons.person_outline,
                isSelected: selectedRole == 'tenant',
                onTap: () => onRoleChanged('tenant'),
              ),
            ),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: _RoleChip(
                label: AppStrings.landlord,
                icon: Icons.home_outlined,
                isSelected: selectedRole == 'landlord',
                onTap: () => onRoleChanged('landlord'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.spacing14,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected
                ? AppDimensions.borderMedium
                : AppDimensions.borderThin,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppDimensions.iconSmall,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: AppDimensions.spacing8),
            AppText(
              label,
              fontSize: AppTypography.fontSize14,
              fontWeight: AppTypography.weightSemiBold,
              color: isSelected ? AppColors.white : AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
