import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/empty_state_card.dart';
import '../../../../core/widgets/shimmer_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../bookings/domain/entities/booking_entity.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_card.dart';

class BookingListScreen extends ConsumerStatefulWidget {
  const BookingListScreen({super.key});

  @override
  ConsumerState<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends ConsumerState<BookingListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isLandlord =
          ref.read(authViewModelProvider).user?.isLandlord == true;
      ref
          .read(bookingListViewModelProvider.notifier)
          .loadBookings(refresh: true, isLandlord: isLandlord);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingListViewModelProvider);
    final isLandlord =
        ref.watch(authViewModelProvider).user?.isLandlord == true;

    final upcoming = state.bookings
        .where((b) =>
            b.status == BookingStatus.confirmed ||
            b.status == BookingStatus.pendingPayment)
        .toList();
    final past = state.bookings
        .where((b) =>
            b.status == BookingStatus.completed ||
            b.status == BookingStatus.cancelled)
        .toList();

    Future<void> reload() => ref
        .read(bookingListViewModelProvider.notifier)
        .loadBookings(refresh: true, isLandlord: isLandlord);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            color: AppColors.surface,
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isLandlord
                                    ? 'Guest Bookings'
                                    : 'My Bookings',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isLandlord
                                    ? '${state.bookings.length} booking${state.bookings.length != 1 ? 's' : ''} on your listings'
                                    : '${state.bookings.length} total reservation${state.bookings.length != 1 ? 's' : ''}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12.5,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Stats pill
                        if (upcoming.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${upcoming.length} active',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  // ── Tab bar ──────────────────────────────────────────────
                  _BookingTabBar(
                    controller: _tabController,
                    allCount: state.bookings.length,
                    upcomingCount: upcoming.length,
                    pastCount: past.length,
                  ),
                ],
              ),
            ),
          ),

          // ── Body ────────────────────────────────────────────────────────
          Expanded(
            child: state.isLoading
                ? ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: 4,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, __) => const ShimmerCard(height: 160),
                  )
                : state.isFailure
                    ? EmptyStateCard.error(
                        message:
                            state.errorMessage ?? 'Failed to load bookings',
                        onRetry: reload,
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _BookingTabView(
                            bookings: state.bookings,
                            isLandlord: isLandlord,
                            onRefresh: reload,
                          ),
                          _BookingTabView(
                            bookings: upcoming,
                            isLandlord: isLandlord,
                            emptyTitle: isLandlord
                                ? 'No active bookings'
                                : 'No upcoming bookings',
                            emptyMessage: isLandlord
                                ? 'Confirmed guest bookings will appear here.'
                                : 'Your confirmed bookings will appear here.',
                            onRefresh: reload,
                          ),
                          _BookingTabView(
                            bookings: past,
                            isLandlord: isLandlord,
                            emptyTitle: 'No past bookings',
                            emptyMessage: isLandlord
                                ? 'Completed and cancelled bookings will appear here.'
                                : 'Your completed bookings will appear here.',
                            onRefresh: reload,
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}

// ── Custom tab bar ────────────────────────────────────────────────────────────

class _BookingTabBar extends StatelessWidget {
  const _BookingTabBar({
    required this.controller,
    required this.allCount,
    required this.upcomingCount,
    required this.pastCount,
  });

  final TabController controller;
  final int allCount;
  final int upcomingCount;
  final int pastCount;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: false,
      labelPadding: EdgeInsets.zero,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.primary, width: 2.5),
        insets: EdgeInsets.symmetric(horizontal: 16),
      ),
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textSecondary,
      labelStyle: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      dividerColor: AppColors.border,
      tabs: [
        _Tab(label: 'All', count: allCount),
        _Tab(label: 'Upcoming', count: upcomingCount),
        _Tab(label: 'Past', count: pastCount),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.label, required this.count});
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Tab view ──────────────────────────────────────────────────────────────────

class _BookingTabView extends StatelessWidget {
  const _BookingTabView({
    required this.bookings,
    this.isLandlord = false,
    this.emptyTitle = 'No bookings yet',
    this.emptyMessage = 'Your bookings will appear here.',
    required this.onRefresh,
  });

  final List<BookingEntity> bookings;
  final bool isLandlord;
  final String emptyTitle;
  final String emptyMessage;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return EmptyStateCard(
        title: emptyTitle,
        message: emptyMessage,
        icon: Icons.calendar_today_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => BookingCard(
          booking: bookings[index],
          showPropertyInfo: isLandlord,
          onTap: isLandlord
              ? null
              : () => context.push(
                  AppRoutes.bookingDetailPath(bookings[index].id)),
        ),
      ),
    );
  }
}
