import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../payments/domain/entities/payment_entity.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({super.key, required this.payment});

  final PaymentEntity payment;

  @override
  Widget build(BuildContext context) {
    final (statusColor, statusBg, statusLabel) = _statusInfo();

    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          AppDimensions.cardRadius - AppDimensions.spacing2,
        ),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: AppDimensions.iconXLarge,
            height: AppDimensions.iconXLarge,
            decoration: BoxDecoration(
              color: statusBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _statusIcon(),
              color: statusColor,
              size: AppDimensions.iconSmall20 + AppDimensions.spacing2,
            ),
          ),
          const SizedBox(width: AppDimensions.spacing14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Booking #${payment.bookingId.substring(0, 8).toUpperCase()}',
                  fontSize: AppTypography.fontSize14,
                  fontWeight: AppTypography.weightSemiBold,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(height: AppDimensions.spacing2 + AppDimensions.spacing2),
                AppText(
                  'Ref: ${payment.reference}',
                  fontSize: AppTypography.fontSize12 - 1,
                  color: AppColors.textSecondary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (payment.paidAt != null || payment.createdAt != null) ...[
                  const SizedBox(height: AppDimensions.spacing2 + AppDimensions.spacing2),
                  AppText(
                    _formatDate(payment.paidAt ?? payment.createdAt ?? ''),
                    fontSize: AppTypography.fontSize12 - 1,
                    color: AppColors.textLight,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                CurrencyFormatter.format(payment.amount),
                fontSize: AppTypography.fontSize16,
                fontWeight: AppTypography.weightBold,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppDimensions.spacing4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing8,
                  vertical: AppDimensions.spacing2 + AppDimensions.spacing2 - AppDimensions.spacing2,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: AppText(
                  statusLabel,
                  fontSize: AppTypography.fontSize10,
                  fontWeight: AppTypography.weightSemiBold,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  (Color, Color, String) _statusInfo() {
    switch (payment.status) {
      case PaymentStatus.success:
        return (AppColors.success, AppColors.successLight, 'Success');
      case PaymentStatus.failed:
        return (AppColors.error, AppColors.errorLight, 'Failed');
      case PaymentStatus.abandoned:
        return (AppColors.warning, AppColors.warningLight, 'Abandoned');
      case PaymentStatus.pending:
        return (AppColors.info, AppColors.infoLight, 'Pending');
    }
  }

  IconData _statusIcon() {
    switch (payment.status) {
      case PaymentStatus.success:
        return Icons.check_circle_outline;
      case PaymentStatus.failed:
        return Icons.cancel_outlined;
      case PaymentStatus.abandoned:
        return Icons.warning_amber_outlined;
      case PaymentStatus.pending:
        return Icons.hourglass_empty_outlined;
    }
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return dateStr.length > 10 ? dateStr.substring(0, 10) : dateStr;
    }
  }
}
