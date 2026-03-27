import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/booking_status_badge.dart';
import '../../../../core/widgets/buttons/custom_button.dart';
import '../../../../core/widgets/empty_state_card.dart';
import '../../../../core/widgets/shimmer_card.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../../app/flavors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../payments/presentation/providers/payment_provider.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_info_row.dart';

class BookingDetailScreen extends ConsumerStatefulWidget {
  const BookingDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  ConsumerState<BookingDetailScreen> createState() =>
      _BookingDetailScreenState();
}

class _BookingDetailScreenState extends ConsumerState<BookingDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(bookingDetailViewModelProvider.notifier)
          .loadBooking(widget.bookingId);
    });
  }

  Future<void> _cancelBooking() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        title: AppText(
          AppStrings.cancelBooking,
          fontWeight: AppTypography.weightBold,
          fontSize: AppTypography.fontSize16,
        ),
        content: AppText.body(AppStrings.cancelBookingConfirm),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pop(ctx, false),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing16,
                vertical: AppDimensions.spacing12,
              ),
              child: AppText(
                AppStrings.cancel,
                color: AppColors.textSecondary,
                fontWeight: AppTypography.weightMedium,
              ),
            ),
          ),
          CustomButton.destructive(
            text: AppStrings.cancelBooking,
            onPressed: () => Navigator.pop(ctx, true),
            width: AppDimensions.spacing96 + AppDimensions.spacing32,
            height: AppDimensions.buttonHeightSmall,
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final success = await ref
        .read(bookingDetailViewModelProvider.notifier)
        .cancelBooking(widget.bookingId);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(AppStrings.bookingCancelledSuccess),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      final error =
          ref.read(bookingDetailViewModelProvider).errorMessage ??
              AppStrings.bookingCancelFailed;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: AppText(error), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingDetailViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppHeader(
        title: AppStrings.bookingDetails,
        onBackPressed: () => context.pop(),
      ),
      body: state.isLoading
          ? const ShimmerBookingDetail()
          : state.isFailure
              ? EmptyStateCard.error(
                  message:
                      state.errorMessage ?? 'Failed to load booking',
                  onRetry: () => ref
                      .read(bookingDetailViewModelProvider.notifier)
                      .loadBooking(widget.bookingId),
                )
              : state.booking == null
                  ? const SizedBox.shrink()
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            color: AppColors.surface,
                            padding:
                                const EdgeInsets.all(AppDimensions.spacing20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(
                                      'Booking ID',
                                      fontSize: AppTypography.fontSize12,
                                      color: AppColors.textSecondary,
                                    ),
                                    BookingStatusBadge(
                                        status: state.booking!.status),
                                  ],
                                ),
                                const SizedBox(
                                    height: AppDimensions.spacing4),
                                AppText(
                                  '#${state.booking!.id.substring(0, 12).toUpperCase()}',
                                  fontSize: AppTypography.fontSize18,
                                  fontWeight: AppTypography.weightBold,
                                  color: AppColors.textPrimary,
                                  letterSpacing: 0.5,
                                ),
                                const SizedBox(
                                    height: AppDimensions.spacing16),
                                Container(
                                  padding: const EdgeInsets.all(
                                      AppDimensions.cardPadding),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(
                                        AppDimensions.radiusMedium),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.home_outlined,
                                        size: AppDimensions.iconSmall20,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(
                                          width: AppDimensions.spacing12),
                                      Expanded(
                                        child: AppText(
                                          state.booking!.propertyTitle ??
                                              'Property',
                                          fontSize: AppTypography.fontSize14,
                                          fontWeight:
                                              AppTypography.weightSemiBold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => context.push(
                                            AppRoutes.propertyDetailPath(
                                                state.booking!.propertyId)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: AppDimensions.spacing8,
                                            vertical: AppDimensions.spacing6,
                                          ),
                                          child: AppText(
                                            AppStrings.viewDetails,
                                            fontSize: AppTypography.fontSize12,
                                            fontWeight: AppTypography.weightSemiBold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacing8),
                          Container(
                            color: AppColors.surface,
                            padding:
                                const EdgeInsets.all(AppDimensions.spacing20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  'Stay Details',
                                  fontSize: AppTypography.fontSize16,
                                  fontWeight: AppTypography.weightBold,
                                  color: AppColors.textPrimary,
                                ),
                                const SizedBox(
                                    height: AppDimensions.spacing16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: BookingInfoRow(
                                        icon: Icons.flight_land_outlined,
                                        label: AppStrings.checkIn,
                                        value: _formatDate(
                                            state.booking!.checkIn),
                                      ),
                                    ),
                                    const SizedBox(
                                        width: AppDimensions.spacing12),
                                    Expanded(
                                      child: BookingInfoRow(
                                        icon: Icons.flight_takeoff_outlined,
                                        label: AppStrings.checkOut,
                                        value: _formatDate(
                                            state.booking!.checkOut),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                    height: AppDimensions.spacing12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: BookingInfoRow(
                                        icon: Icons.nights_stay_outlined,
                                        label: AppStrings.nights,
                                        value: '${state.booking!.nights}',
                                      ),
                                    ),
                                    const SizedBox(
                                        width: AppDimensions.spacing12),
                                    Expanded(
                                      child: BookingInfoRow(
                                        icon: Icons.group_outlined,
                                        label: AppStrings.guestsLabel,
                                        value: '${state.booking!.guests}',
                                      ),
                                    ),
                                  ],
                                ),
                                if (state.booking!.notes != null &&
                                    state.booking!.notes!.isNotEmpty) ...[
                                  const SizedBox(
                                      height: AppDimensions.spacing16),
                                  AppText(
                                    AppStrings.notes,
                                    fontSize: AppTypography.fontSize13,
                                    fontWeight: AppTypography.weightSemiBold,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(
                                      height: AppDimensions.spacing6),
                                  AppText(
                                    state.booking!.notes!,
                                    fontSize: AppTypography.fontSize14,
                                    color: AppColors.textPrimary,
                                    height: 1.5,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacing8),
                          Container(
                            color: AppColors.surface,
                            padding:
                                const EdgeInsets.all(AppDimensions.spacing20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  'Payment Summary',
                                  fontSize: AppTypography.fontSize16,
                                  fontWeight: AppTypography.weightBold,
                                  color: AppColors.textPrimary,
                                ),
                                const SizedBox(
                                    height: AppDimensions.spacing16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(
                                      AppStrings.totalAmount,
                                      color: AppColors.textSecondary,
                                    ),
                                    AppText(
                                      CurrencyFormatter.format(state.booking!.totalAmount),
                                      fontSize: AppTypography.fontSize20,
                                      fontWeight: AppTypography.weightExtraBold,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                                if (state.booking!.paymentRef != null) ...[
                                  const SizedBox(
                                      height: AppDimensions.spacing8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText(
                                        'Payment Ref',
                                        fontSize: AppTypography.fontSize13,
                                        color: AppColors.textSecondary,
                                      ),
                                      AppText(
                                        state.booking!.paymentRef!,
                                        fontSize: AppTypography.fontSize13,
                                        fontWeight: AppTypography.weightMedium,
                                        color: AppColors.textPrimary,
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacing24),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.spacing20),
                            child: Column(
                              children: [
                                if (state.booking!.needsPayment) ...[
                                  CustomButton.secondary(
                                    text: AppStrings.payNow,
                                    onPressed: () {
                                      context.push(
                                        AppRoutes.paymentProcess,
                                        extra: {
                                          'booking_id': state.booking!.id,
                                          'email': ref.read(authViewModelProvider).user?.email ?? '',
                                          'amount':
                                              state.booking!.totalAmount,
                                          'public_key': ref.watch(paystackPublicKeyProvider).valueOrNull ?? FlavorConfig.shared.paystackPublicKey,
                                        },
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                      height: AppDimensions.spacing12),
                                ],
                                if (state.booking!.canCancel)
                                  CustomButton.outlined(
                                    text: state.isCancelling
                                        ? 'Cancelling...'
                                        : AppStrings.cancelBooking,
                                    onPressed: state.isCancelling
                                        ? null
                                        : _cancelBooking,
                                    isLoading: state.isCancelling,
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacing40),
                        ],
                      ),
                    ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      const months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December',
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return dateStr;
    }
  }
}
