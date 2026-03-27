import 'package:cached_network_image/cached_network_image.dart';
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
import '../../../../core/widgets/buttons/custom_button.dart';
import '../../../../core/widgets/empty_state_card.dart';
import '../../../../core/widgets/shimmer_card.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../providers/property_provider.dart';

class MyListingsScreen extends ConsumerStatefulWidget {
  const MyListingsScreen({super.key});

  @override
  ConsumerState<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends ConsumerState<MyListingsScreen> {
  bool _isLoading = true;
  String? _error;
  List<dynamic> _properties = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetch());
  }

  Future<void> _fetch() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final repo = ref.read(propertyRepositoryProvider);
    final result = await repo.getMyProperties();
    if (!mounted) return;
    if (result.isSuccess) {
      setState(() {
        _properties = result.data ?? [];
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = result.errorOrEmpty;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteProperty(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        title: AppText(
          AppStrings.deleteProperty,
          fontWeight: AppTypography.weightBold,
          fontSize: AppTypography.fontSize16,
        ),
        content: AppText.body(AppStrings.deletePropertyConfirm),
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
            text: AppStrings.delete,
            onPressed: () => Navigator.pop(ctx, true),
            width: AppDimensions.spacing80,
            height: AppDimensions.buttonHeightSmall,
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final repo = ref.read(propertyRepositoryProvider);
    final result = await repo.deleteProperty(id);
    if (!mounted) return;

    if (result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(AppStrings.propertyDeletedSuccess),
          backgroundColor: AppColors.success,
        ),
      );
      _fetch();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(result.errorOrEmpty),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppHeader(
        title: AppStrings.myListings,
        onBackPressed: () => context.pop(),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/property/create');
          if (mounted) _fetch();
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: AppText(
          AppStrings.addProperty,
          color: AppColors.white,
          fontWeight: AppTypography.weightSemiBold,
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ListView.separated(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        itemCount: 5,
        separatorBuilder: (_, __) =>
            const SizedBox(height: AppDimensions.spacing12),
        itemBuilder: (_, __) =>
            const ShimmerCard(height: AppDimensions.spacing96 + AppDimensions.spacing14),
      );
    }

    if (_error != null) {
      return EmptyStateCard.error(message: _error!, onRetry: _fetch);
    }

    if (_properties.isEmpty) {
      return EmptyStateCard.noListings(
        onAction: () => context.push('/property/create'),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetch,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        itemCount: _properties.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: AppDimensions.spacing12),
        itemBuilder: (context, index) {
          final property = _properties[index];
          return _ListingTile(
            property: property,
            onEdit: () async {
              await context.push(AppRoutes.editPropertyPath(property.id));
              if (mounted) _fetch();
            },
            onDelete: () => _deleteProperty(property.id),
          );
        },
      ),
    );
  }
}

class _ListingTile extends StatelessWidget {
  const _ListingTile({
    required this.property,
    required this.onEdit,
    required this.onDelete,
  });

  final dynamic property;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius:
            BorderRadius.circular(AppDimensions.cardRadius - AppDimensions.spacing2),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(
                  AppDimensions.cardRadius - AppDimensions.spacing2),
            ),
            child: SizedBox(
              width: AppDimensions.spacing96 + AppDimensions.spacing4,
              height: AppDimensions.spacing96 + AppDimensions.spacing14,
              child: property.firstImage.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: property.firstImage,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          const ShimmerCard(height: double.infinity),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.background,
                        child: const Icon(
                          Icons.home_outlined,
                          color: AppColors.border,
                          size: AppDimensions.iconLarge,
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.background,
                      child: const Icon(
                        Icons.home_outlined,
                        color: AppColors.border,
                        size: AppDimensions.iconLarge,
                      ),
                    ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spacing12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    property.title,
                    fontSize: AppTypography.fontSize14,
                    fontWeight: AppTypography.weightSemiBold,
                    color: AppColors.textPrimary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.spacing4),
                  AppText(
                    property.locationSummary,
                    fontSize: AppTypography.fontSize12,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: AppDimensions.spacing6),
                  AppText(
                    CurrencyFormatter.formatPerNight(property.pricePerDay),
                    fontSize: AppTypography.fontSize13,
                    fontWeight: AppTypography.weightBold,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  size: AppDimensions.iconSmall,
                  color: AppColors.primary,
                ),
                onPressed: onEdit,
                tooltip: AppStrings.editProperty,
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: AppDimensions.iconSmall,
                  color: AppColors.error,
                ),
                onPressed: onDelete,
                tooltip: AppStrings.deleteProperty,
              ),
            ],
          ),
          const SizedBox(width: AppDimensions.spacing4),
        ],
      ),
    );
  }
}
