import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/empty_state_card.dart';
import '../../../../core/widgets/shimmer_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/property_provider.dart';
import '../widgets/amenity_chip.dart';
import '../widgets/property_image_carousel.dart';
import '../widgets/property_info_row.dart';

class PropertyDetailScreen extends ConsumerStatefulWidget {
  const PropertyDetailScreen({super.key, required this.propertyId});
  final String propertyId;

  @override
  ConsumerState<PropertyDetailScreen> createState() =>
      _PropertyDetailScreenState();
}

class _PropertyDetailScreenState
    extends ConsumerState<PropertyDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(propertyDetailViewModelProvider.notifier)
          .loadProperty(widget.propertyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(propertyDetailViewModelProvider);
    final currentUser = ref.watch(authViewModelProvider).user;

    if (state.isLoading) {
      return const Scaffold(
        body: ShimmerPropertyDetail(),
      );
    }

    if (state.isFailure) {
      return Scaffold(
        appBar: AppBar(),
        body: EmptyStateCard.error(
          message: state.errorMessage ?? 'Failed to load property',
          onRetry: () => ref
              .read(propertyDetailViewModelProvider.notifier)
              .loadProperty(widget.propertyId),
        ),
      );
    }

    if (state.property == null) return const SizedBox.shrink();

    final property = state.property!;
    final isOwner = currentUser?.id == property.ownerId;
    final isTenant = currentUser?.isTenant == true;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            // Immersive image header
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: AppColors.primary,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
              ),
              leading: Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(100),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              actions: [
                if (isOwner || currentUser?.isLandlord == true)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () => context
                          .push(AppRoutes.editPropertyPath(widget.propertyId)),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(100),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    PropertyImageCarousel(
                      images: property.images,
                      height: double.infinity,
                    ),
                    // Gradient overlay on image
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0x66000000),
                            Colors.transparent,
                            Colors.transparent,
                            Color(0x88000000),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.2, 0.6, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content
            SliverToBoxAdapter(
              child: Container(
                color: AppColors.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badges
                          Row(
                            children: [
                              _Badge(
                                label: property.propertyType.name
                                    .toUpperCase(),
                                color: AppColors.primary,
                                textColor: AppColors.white,
                              ),
                              const SizedBox(width: 8),
                              _Badge(
                                label: property.isAvailable
                                    ? 'Available'
                                    : 'Unavailable',
                                color: property.isAvailable
                                    ? AppColors.successLight
                                    : AppColors.errorLight,
                                textColor: property.isAvailable
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            property.title,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 16, color: AppColors.accent),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${property.address}, ${property.locationSummary}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (property.landlordName != null &&
                              property.landlordName!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.person_outline,
                                    size: 15, color: AppColors.textLight),
                                const SizedBox(width: 4),
                                Text(
                                  'Listed by ${property.landlordName}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.5,
                                    color: AppColors.textLight,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 20),
                          PropertyInfoRow(
                            bedrooms: property.bedrooms,
                            bathrooms: property.bathrooms,
                            maxGuests: property.maxGuests,
                          ),
                          const SizedBox(height: 20),
                          // Price
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFF0F5FF),
                                  Color(0xFFE8F0FF)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Price per night',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      Text(
                                        CurrencyFormatter.format(
                                            property.pricePerDay),
                                        style: GoogleFonts.poppins(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primary,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent,
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.nights_stay_outlined,
                                    color: AppColors.white,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (property.description != null &&
                property.description!.isNotEmpty)
              SliverToBoxAdapter(
                child: _Section(
                  title: 'About this property',
                  child: Text(
                    property.description!,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.7,
                    ),
                  ),
                ),
              ),
            if (property.amenities.isNotEmpty)
              SliverToBoxAdapter(
                child: _Section(
                  title: 'Amenities',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: property.amenities
                        .map((a) => AmenityChip(label: a))
                        .toList(),
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
        bottomNavigationBar: _BookingBar(
          isAvailable: property.isAvailable,
          isTenant: isTenant,
          isOwner: isOwner,
          price: property.pricePerDay,
          onBook: property.isAvailable
              ? () => context.push('/property/${widget.propertyId}/book')
              : null,
          onEdit: isOwner
              ? () => context
                  .push(AppRoutes.editPropertyPath(widget.propertyId))
              : null,
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.color,
    required this.textColor,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      color: AppColors.surface,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _BookingBar extends StatelessWidget {
  const _BookingBar({
    required this.isAvailable,
    required this.isTenant,
    required this.isOwner,
    required this.price,
    this.onBook,
    this.onEdit,
  });

  final bool isAvailable;
  final bool isTenant;
  final bool isOwner;
  final double price;
  final VoidCallback? onBook;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    if (!isTenant && !isOwner) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: isTenant
          ? Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CurrencyFormatter.format(price),
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'per night',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: GestureDetector(
                    onTap: onBook,
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: isAvailable && onBook != null
                            ? const LinearGradient(
                                colors: [
                                  Color(0xFF1E3A5F),
                                  Color(0xFF2D5FA0)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : const LinearGradient(
                                colors: [
                                  Color(0xFFB0BEC5),
                                  Color(0xFFCFD8DC)
                                ],
                              ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: isAvailable
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withAlpha(80),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          isAvailable ? 'Book Now' : 'Not Available',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : GestureDetector(
              onTap: onEdit,
              child: Container(
                height: 52,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 1.5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    'Edit Property',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
