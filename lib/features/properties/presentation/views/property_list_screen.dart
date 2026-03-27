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
import '../providers/property_provider.dart';
import '../widgets/property_card.dart';
import '../widgets/property_list_header.dart';
import '../widgets/property_type_filter.dart';

class PropertyListScreen extends ConsumerStatefulWidget {
  const PropertyListScreen({super.key});

  @override
  ConsumerState<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends ConsumerState<PropertyListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final status = ref.read(propertyListViewModelProvider).status;
      if (status == PropertyListStatus.initial ||
          status == PropertyListStatus.failure) {
        ref
            .read(propertyListViewModelProvider.notifier)
            .loadProperties(refresh: true);
      }
    });
    _scrollController.addListener(_onScroll);
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(propertyListViewModelProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(propertyListViewModelProvider);
    final user = ref.watch(authViewModelProvider).user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Fixed premium header
          PropertyListHeader(
            userName: user?.firstName,
            searchController: _searchController,
            onSearch: (value) {
              ref
                  .read(propertyListViewModelProvider.notifier)
                  .setCityFilter(value);
            },
            onClearSearch: () {
              _searchController.clear();
              ref
                  .read(propertyListViewModelProvider.notifier)
                  .setCityFilter('');
            },
            showListingsButton: user?.isLandlord == true,
            onListingsPressed: user?.isLandlord == true
                ? () => context.push(AppRoutes.myListings)
                : null,
          ),
          // Category filter
          Container(
            color: AppColors.surface,
            child: Column(
              children: [
                PropertyTypeFilter(
                  selectedType: state.selectedType,
                  onTypeSelected: (type) {
                    ref
                        .read(propertyListViewModelProvider.notifier)
                        .setTypeFilter(type);
                  },
                ),
                const Divider(height: 1),
              ],
            ),
          ),
          // Property grid
          Expanded(
            child: _buildBody(state),
          ),
        ],
      ),
      floatingActionButton: user?.isLandlord == true
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/property/create'),
              backgroundColor: AppColors.primary,
              elevation: 4,
              extendedPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              icon: const Icon(Icons.add_rounded,
                  color: AppColors.white, size: 22),
              label: Text(
                'Add Property',
                style: GoogleFonts.poppins(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildBody(dynamic state) {
    if (state.isLoading) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => const ShimmerPropertyCard(),
      );
    }

    if (state.isFailure) {
      return EmptyStateCard.error(
        message: state.errorMessage ?? 'Failed to load properties',
        onRetry: () => ref
            .read(propertyListViewModelProvider.notifier)
            .loadProperties(refresh: true),
      );
    }

    if (state.properties.isEmpty) {
      return EmptyStateCard.noProperties(
        onAction: () => ref
            .read(propertyListViewModelProvider.notifier)
            .clearFilters(),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => ref
          .read(propertyListViewModelProvider.notifier)
          .loadProperties(refresh: true),
      color: AppColors.primary,
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount:
            state.properties.length + (state.isLoadingMore ? 2 : 0),
        itemBuilder: (context, index) {
          if (index >= state.properties.length) {
            return const ShimmerPropertyCard();
          }
          final property = state.properties[index];
          return PropertyCard(
            property: property,
            onTap: () =>
                context.push(AppRoutes.propertyDetailPath(property.id)),
          );
        },
      ),
    );
  }
}
