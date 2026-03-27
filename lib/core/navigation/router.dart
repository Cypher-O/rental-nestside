import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/auth/presentation/views/login_screen.dart';
import '../../features/auth/presentation/views/register_screen.dart';
import '../../features/auth/presentation/views/profile_screen.dart';
import '../../features/properties/presentation/views/property_list_screen.dart';
import '../../features/properties/presentation/views/property_detail_screen.dart';
import '../../features/properties/presentation/views/create_property_screen.dart';
import '../../features/properties/presentation/views/my_listings_screen.dart';
import '../../features/bookings/presentation/views/booking_list_screen.dart';
import '../../features/bookings/presentation/views/booking_detail_screen.dart';
import '../../features/bookings/presentation/views/create_booking_screen.dart';
import '../../features/payments/presentation/views/payment_history_screen.dart';
import '../../features/payments/presentation/views/payment_process_screen.dart';
import '../../shared/providers/app_state_provider.dart';
import '../enums/app_enums.dart';
import '../theme/app_colors.dart';
import 'routes.dart';

// ── Transition helpers ────────────────────────────────────────────────────────

/// Native iOS slide + swipe-back gesture via CupertinoPage.
Page<void> _slidePage(LocalKey key, Widget child) {
  return CupertinoPage<void>(key: key, child: child);
}

/// Fade – used for auth root routes and tab switches.
Page<void> _fadePage(LocalKey key, Widget child) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 220),
    reverseTransitionDuration: const Duration(milliseconds: 180),
    transitionsBuilder: (_, animation, __, child) => FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
      child: child,
    ),
  );
}

// ── Bottom nav ────────────────────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

const _navItems = [
  _NavItem(
    icon: Icons.explore_outlined,
    activeIcon: Icons.explore,
    label: 'Explore',
  ),
  _NavItem(
    icon: Icons.calendar_month_outlined,
    activeIcon: Icons.calendar_month,
    label: 'Bookings',
  ),
  _NavItem(
    icon: Icons.receipt_long_outlined,
    activeIcon: Icons.receipt_long,
    label: 'Payments',
  ),
  _NavItem(
    icon: Icons.person_outline_rounded,
    activeIcon: Icons.person_rounded,
    label: 'Profile',
  ),
];

class _AppShell extends ConsumerStatefulWidget {
  const _AppShell({required this.child});
  final Widget child;

  @override
  ConsumerState<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<_AppShell> {
  int _selectedIndex = 0;

  static const _routes = [
    AppRoutes.home,
    AppRoutes.bookings,
    AppRoutes.payments,
    AppRoutes.profile,
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: _PremiumNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _PremiumNavBar extends StatelessWidget {
  const _PremiumNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(12),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            bottom: bottom > 0 ? 4 : 10,
            left: 8,
            right: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final isSelected = selectedIndex == index;
              return _NavBarItem(
                item: item,
                isSelected: isSelected,
                onTap: () => onTap(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withAlpha(14)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? item.activeIcon : item.icon,
                key: ValueKey(isSelected),
                color: isSelected ? AppColors.primary : AppColors.textLight,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: GoogleFonts.poppins(
                fontSize: 10.5,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.textLight,
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Splash ────────────────────────────────────────────────────────────────────

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.white.withAlpha(20),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.home_work_rounded,
                color: AppColors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'NestFinder',
              style: GoogleFonts.poppins(
                color: AppColors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 48),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Router ────────────────────────────────────────────────────────────────────
//
// STRUCTURE:
//   Top-level routes (no shell / no bottom nav):
//     /splash, /login, /register
//     /my-listings, /property/create, /property/:id (+ nested edit, book)
//     /bookings/:id, /payment-process
//   ShellRoute (shows bottom nav) – tab roots only:
//     /home, /bookings, /payments, /profile

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      // ── Auth ──────────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (_, state) =>
            _fadePage(state.pageKey, const SplashScreen()),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (_, state) =>
            _fadePage(state.pageKey, const LoginScreen()),
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (_, state) =>
            _slidePage(state.pageKey, const RegisterScreen()),
      ),

      // ── Full-screen pushed routes (NO bottom nav) ─────────────────────────
      GoRoute(
        path: AppRoutes.myListings,
        pageBuilder: (_, state) =>
            _slidePage(state.pageKey, const MyListingsScreen()),
      ),
      GoRoute(
        path: '/property/create',
        pageBuilder: (_, state) =>
            _slidePage(state.pageKey, const CreatePropertyScreen()),
      ),
      GoRoute(
        path: '/property/:id',
        pageBuilder: (_, state) {
          final id = state.pathParameters['id']!;
          return _slidePage(state.pageKey, PropertyDetailScreen(propertyId: id));
        },
        routes: [
          GoRoute(
            path: 'edit',
            pageBuilder: (_, state) {
              final id = state.pathParameters['id']!;
              return _slidePage(
                  state.pageKey, CreatePropertyScreen(propertyId: id));
            },
          ),
          GoRoute(
            path: 'book',
            pageBuilder: (_, state) {
              final id = state.pathParameters['id']!;
              return _slidePage(
                  state.pageKey, CreateBookingScreen(propertyId: id));
            },
          ),
        ],
      ),
      GoRoute(
        path: '/bookings/:id',
        pageBuilder: (_, state) {
          final id = state.pathParameters['id']!;
          return _slidePage(
              state.pageKey, BookingDetailScreen(bookingId: id));
        },
      ),
      GoRoute(
        path: AppRoutes.paymentProcess,
        pageBuilder: (_, state) {
          final extra = state.extra as Map<String, dynamic>;
          return _slidePage(
            state.pageKey,
            PaymentProcessScreen(
              bookingId: extra['booking_id'] as String,
              email: extra['email'] as String,
              amount: extra['amount'] as double,
              publicKey: extra['public_key'] as String,
            ),
          );
        },
      ),

      // ── Shell (tab roots – shows bottom nav) ──────────────────────────────
      ShellRoute(
        builder: (context, state, child) => _AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (_, state) =>
                _fadePage(state.pageKey, const PropertyListScreen()),
          ),
          GoRoute(
            path: AppRoutes.bookings,
            pageBuilder: (_, state) =>
                _fadePage(state.pageKey, const BookingListScreen()),
          ),
          GoRoute(
            path: AppRoutes.payments,
            pageBuilder: (_, state) =>
                _fadePage(state.pageKey, const PaymentHistoryScreen()),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (_, state) =>
                _fadePage(state.pageKey, const ProfileScreen()),
          ),
        ],
      ),
    ],
  );
});

// ── Router notifier ───────────────────────────────────────────────────────────

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref.listen<AppState>(appStateProvider, (_, __) => notifyListeners());
  }

  final Ref _ref;

  static const _publicPaths = {
    AppRoutes.splash,
    AppRoutes.login,
    AppRoutes.register,
  };

  String? redirect(BuildContext context, GoRouterState state) {
    final appStatus = _ref.read(appStateProvider).status;
    final location = state.matchedLocation;

    if (appStatus == AppStatus.loading) {
      if (location != AppRoutes.splash) return AppRoutes.splash;
      return null;
    }

    final isAuthenticated = appStatus == AppStatus.authenticated;

    if (isAuthenticated &&
        (location == AppRoutes.login ||
            location == AppRoutes.register ||
            location == AppRoutes.splash)) {
      return AppRoutes.home;
    }

    if (!isAuthenticated && !_publicPaths.contains(location)) {
      return AppRoutes.login;
    }

    if (!isAuthenticated && location == AppRoutes.splash) {
      return AppRoutes.login;
    }

    return null;
  }
}
