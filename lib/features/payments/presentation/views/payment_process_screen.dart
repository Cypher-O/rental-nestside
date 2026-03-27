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
import '../../../../core/widgets/buttons/button_icon.dart';
import '../../../../core/widgets/buttons/custom_button.dart';
import '../../../../core/widgets/loading/loading_indicator.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../providers/payment_provider.dart';
import '../widgets/card_payment_sheet.dart';
import '../widgets/payment_step_icon.dart';

enum _Step { idle, initializing, verifying, succeeded, failed }

class PaymentProcessScreen extends ConsumerStatefulWidget {
  const PaymentProcessScreen({
    super.key,
    required this.bookingId,
    required this.email,
    required this.amount,
    required this.publicKey,
  });

  final String bookingId;
  final String email;
  final double amount;
  final String publicKey;

  @override
  ConsumerState<PaymentProcessScreen> createState() =>
      _PaymentProcessScreenState();
}

class _PaymentProcessScreenState
    extends ConsumerState<PaymentProcessScreen> {
  _Step _step = _Step.idle;
  String? _errorMessage;
  String? _reference;

  Future<void> _startPayment() async {
    setState(() {
      _step = _Step.initializing;
      _errorMessage = null;
    });

    final success = await ref
        .read(paymentInitViewModelProvider.notifier)
        .initializePayment(
          bookingId: widget.bookingId,
          email: widget.email.isNotEmpty ? widget.email : 'user@rentease.app',
        );

    if (!mounted) return;

    if (!success) {
      setState(() {
        _step = _Step.failed;
        _errorMessage =
            ref.read(paymentInitViewModelProvider).errorMessage ??
                'Failed to initialize payment';
      });
      return;
    }

    final initData = ref.read(paymentInitViewModelProvider).initPayment;
    if (initData == null) {
      setState(() {
        _step = _Step.failed;
        _errorMessage = 'Payment reference not found';
      });
      return;
    }

    _reference = initData.reference;
    setState(() => _step = _Step.idle);

    // Show card payment bottom sheet
    final paid = await CardPaymentSheet.show(
      context,
      amount: widget.amount,
      email: widget.email,
      reference: _reference!,
      publicKey: widget.publicKey,
    );

    if (!mounted) return;

    if (paid) {
      await _verifyPayment();
    }
    // If not paid (user dismissed), stay on idle so they can retry
  }

  Future<void> _verifyPayment() async {
    if (_reference == null) return;
    setState(() {
      _step = _Step.verifying;
      _errorMessage = null;
    });

    final success = await ref
        .read(paymentInitViewModelProvider.notifier)
        .verifyPayment(_reference!);

    if (!mounted) return;

    setState(() =>
        _step = success ? _Step.succeeded : _Step.failed);

    if (!success) {
      _errorMessage =
          ref.read(paymentInitViewModelProvider).errorMessage ??
              'Payment verification failed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppHeader(
        title: AppStrings.payments,
        onBackPressed: _step == _Step.idle || _step == _Step.failed
            ? () => context.pop()
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.modalPadding),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_step) {
      case _Step.initializing:
        return _centered(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LoadingIndicator(),
              const SizedBox(height: AppDimensions.spacing16),
              AppText(
                AppStrings.initializingPayment,
                fontSize: AppTypography.fontSize16,
                fontWeight: AppTypography.weightSemiBold,
                color: AppColors.textPrimary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacing8),
              AppText(
                'Setting up your payment...',
                fontSize: AppTypography.fontSize13,
                color: AppColors.textSecondary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );

      case _Step.verifying:
        return _centered(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LoadingIndicator(),
              const SizedBox(height: AppDimensions.spacing16),
              AppText(
                AppStrings.verifyingPayment,
                fontSize: AppTypography.fontSize16,
                fontWeight: AppTypography.weightSemiBold,
                color: AppColors.textPrimary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacing8),
              AppText(
                'Confirming your transaction...',
                fontSize: AppTypography.fontSize13,
                color: AppColors.textSecondary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );

      case _Step.succeeded:
        return _centered(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PaymentStepIcon.success(),
              const SizedBox(height: AppDimensions.spacing24),
              AppText(
                AppStrings.paymentSuccessful,
                fontSize: AppTypography.fontSize24,
                fontWeight: AppTypography.weightExtraBold,
                color: AppColors.success,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacing12),
              AppText(
                AppStrings.bookingConfirmed,
                fontSize: AppTypography.fontSize14,
                color: AppColors.textSecondary,
                textAlign: TextAlign.center,
                height: 1.6,
              ),
              const SizedBox(height: AppDimensions.spacing36),
              CustomButton.secondary(
                text: AppStrings.viewMyBookings,
                onPressed: () => context.go(AppRoutes.bookings),
              ),
            ],
          ),
        );

      case _Step.failed:
        return _centered(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PaymentStepIcon.error(),
              const SizedBox(height: AppDimensions.spacing24),
              AppText(
                AppStrings.paymentFailed,
                fontSize: AppTypography.fontSize22,
                fontWeight: AppTypography.weightExtraBold,
                color: AppColors.error,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacing12),
              AppText(
                _errorMessage ?? AppStrings.tryAgainLater,
                fontSize: AppTypography.fontSize14,
                color: AppColors.textSecondary,
                textAlign: TextAlign.center,
                height: 1.6,
              ),
              const SizedBox(height: AppDimensions.spacing36),
              CustomButton.secondary(
                text: AppStrings.tryAgain,
                onPressed: _startPayment,
              ),
              const SizedBox(height: AppDimensions.spacing12),
              CustomButton.outlined(
                text: AppStrings.goBack,
                onPressed: () => context.pop(),
              ),
            ],
          ),
        );

      case _Step.idle:
        return _centered(child: _buildPaymentCard());
    }
  }

  Widget _buildPaymentCard() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacing20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Container(
                width: AppDimensions.spacing64,
                height: AppDimensions.spacing64,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.credit_card_rounded,
                  color: AppColors.primary,
                  size: AppDimensions.iconLarge,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing16),
              AppText(
                AppStrings.completePayment,
                fontSize: AppTypography.fontSize18,
                fontWeight: AppTypography.weightBold,
                color: AppColors.textPrimary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacing8),
              AppText(
                'Booking ID: ${widget.bookingId.substring(0, 8)}...',
                fontSize: AppTypography.fontSize13,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: AppDimensions.spacing20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing24,
                  vertical: AppDimensions.spacing16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(10),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: Column(
                  children: [
                    AppText(
                      AppStrings.totalAmount,
                      fontSize: AppTypography.fontSize13,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: AppDimensions.spacing4),
                    AppText(
                      CurrencyFormatter.format(widget.amount),
                      fontSize: AppTypography.fontSize32,
                      fontWeight: AppTypography.weightExtraBold,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacing32),
        CustomButton.secondary(
          text: AppStrings.payWithCard,
          onPressed: _startPayment,
          icon: const ButtonIcon.material(Icons.credit_card_rounded),
        ),
        const SizedBox(height: AppDimensions.spacing16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outlined,
              size: AppDimensions.iconSmall,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppDimensions.spacing4),
            AppText(
              AppStrings.securePayment,
              fontSize: AppTypography.fontSize12,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _centered({required Widget child}) {
    return Center(
      child: SingleChildScrollView(child: child),
    );
  }

}
