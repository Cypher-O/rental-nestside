import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import 'buttons/custom_button.dart';
import 'text/app_text.dart';

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    this.iconBackgroundColor,
  });

  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  factory EmptyStateCard.noProperties({
    Key? key,
    VoidCallback? onAction,
  }) =>
      EmptyStateCard(
        key: key,
        title: AppStrings.noPropertiesFound,
        message: AppStrings.noPropertiesMessage,
        icon: Icons.home_outlined,
        actionLabel: AppStrings.clearFilters,
        onAction: onAction,
      );

  factory EmptyStateCard.noBookings({
    Key? key,
    VoidCallback? onAction,
  }) =>
      EmptyStateCard(
        key: key,
        title: AppStrings.noBookings,
        message: AppStrings.noBookingsMessage,
        icon: Icons.calendar_today_outlined,
        actionLabel: onAction != null ? AppStrings.home : null,
        onAction: onAction,
      );

  factory EmptyStateCard.noPayments({
    Key? key,
  }) =>
      EmptyStateCard(
        key: key,
        title: AppStrings.noPayments,
        message: AppStrings.noPaymentsMessage,
        icon: Icons.payment_outlined,
      );

  factory EmptyStateCard.noListings({
    Key? key,
    VoidCallback? onAction,
  }) =>
      EmptyStateCard(
        key: key,
        title: AppStrings.noListings,
        message: AppStrings.noListingsMessage,
        icon: Icons.home_work_outlined,
        actionLabel: AppStrings.createFirstListing,
        onAction: onAction,
      );

  factory EmptyStateCard.error({
    Key? key,
    String? message,
    VoidCallback? onRetry,
  }) =>
      EmptyStateCard(
        key: key,
        title: AppStrings.somethingWentWrong,
        message: message ?? AppStrings.tryAgainLater,
        icon: Icons.error_outline_rounded,
        actionLabel: AppStrings.retry,
        onAction: onRetry,
        iconColor: AppColors.error,
        iconBackgroundColor: AppColors.errorLight,
      );

  @override
  Widget build(BuildContext context) {
    final resolvedIconColor = iconColor ?? AppColors.primary.withAlpha(150);
    final resolvedIconBg =
        iconBackgroundColor ?? AppColors.primary.withAlpha(15);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppDimensions.iconXLarge + AppDimensions.spacing40,
              height: AppDimensions.iconXLarge + AppDimensions.spacing40,
              decoration: BoxDecoration(
                color: resolvedIconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: resolvedIconColor,
                size: AppDimensions.iconXLarge - AppDimensions.spacing4,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing24),
            AppText.subheading(
              title,
              textAlign: TextAlign.center,
              color: AppColors.textPrimary,
            ),
            const SizedBox(height: AppDimensions.spacing8),
            AppText.body(
              message,
              textAlign: TextAlign.center,
              color: AppColors.textSecondary,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppDimensions.spacing28),
              CustomButton.secondary(
                text: actionLabel!,
                onPressed: onAction,
                width: AppDimensions.spacing96 * 2,
                height: AppDimensions.buttonHeightSmall + AppDimensions.spacing4,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
