import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';
import '../theme/app_colors.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({
    super.key,
    this.title,
    this.onBackPressed,
    this.trailing,
    this.backgroundColor = AppColors.surface,
    this.foregroundColor = AppColors.textPrimary,
  });

  final String? title;
  final VoidCallback? onBackPressed;
  final Widget? trailing;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: 0,
      centerTitle: false,
      leading: onBackPressed != null
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: AppDimensions.iconSmall20,
                color: foregroundColor,
              ),
              onPressed: onBackPressed,
            )
          : null,
      title: title != null
          ? Text(
              title!,
              style: AppTypography.h4.copyWith(color: foregroundColor),
            )
          : null,
      actions: trailing != null
          ? [
              Padding(
                padding:
                    const EdgeInsets.only(right: AppDimensions.spacing16),
                child: trailing,
              ),
            ]
          : null,
    );
  }
}
