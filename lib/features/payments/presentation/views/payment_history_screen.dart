import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/empty_state_card.dart';
import '../../../../core/widgets/shimmer_card.dart';
import '../providers/payment_provider.dart';
import '../widgets/payment_card.dart';

class PaymentHistoryScreen extends ConsumerStatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  ConsumerState<PaymentHistoryScreen> createState() =>
      _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends ConsumerState<PaymentHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentHistoryViewModelProvider.notifier).loadHistory(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paymentHistoryViewModelProvider);

    final successCount = state.payments
        .where((p) => p.status == PaymentStatus.success)
        .length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Container(
            color: AppColors.surface,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Payments',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Track all your transactions',
                                style: GoogleFonts.poppins(
                                  fontSize: 12.5,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Receipt icon box
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.receipt_long_outlined,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    // ── Summary row ─────────────────────────────────────────
                    if (state.payments.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _SummaryStat(
                            label: 'Total',
                            value: '${state.payments.length}',
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          _SummaryStat(
                            label: 'Successful',
                            value: '$successCount',
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 8),
                          _SummaryStat(
                            label: 'Pending / Failed',
                            value:
                                '${state.payments.length - successCount}',
                            color: AppColors.warning,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.border),

          // ── Body ──────────────────────────────────────────────────────────
          Expanded(
            child: state.isLoading
                ? ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: 6,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, __) => const ShimmerCard(height: 90),
                  )
                : state.isFailure
                    ? EmptyStateCard.error(
                        message:
                            state.errorMessage ?? 'Failed to load payments',
                        onRetry: () => ref
                            .read(paymentHistoryViewModelProvider.notifier)
                            .loadHistory(refresh: true),
                      )
                    : state.payments.isEmpty
                        ? EmptyStateCard.noPayments()
                        : RefreshIndicator(
                            onRefresh: () => ref
                                .read(paymentHistoryViewModelProvider.notifier)
                                .loadHistory(refresh: true),
                            color: AppColors.primary,
                            child: ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: state.payments.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) =>
                                  PaymentCard(payment: state.payments[index]),
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withAlpha(12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
