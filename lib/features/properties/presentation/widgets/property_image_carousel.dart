import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/shimmer_card.dart';

class PropertyImageCarousel extends StatelessWidget {
  const PropertyImageCarousel({
    super.key,
    required this.images,
    this.height = 260,
  });

  final List<String> images;
  final double height;

  @override
  Widget build(BuildContext context) {
    final firstImage = images.isNotEmpty ? images.first : '';

    return SizedBox(
      height: height,
      width: double.infinity,
      child: firstImage.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: firstImage,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  const ShimmerCard(height: double.infinity),
              errorWidget: (_, __, ___) => _placeholder(),
            )
          : _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.background,
      child: const Center(
        child: Icon(
          Icons.home_outlined,
          size: AppDimensions.iconXLarge + AppDimensions.spacing16,
          color: AppColors.border,
        ),
      ),
    );
  }
}
