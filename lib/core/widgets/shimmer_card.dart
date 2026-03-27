import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_colors.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({
    super.key,
    this.height = 200,
    this.width,
    this.borderRadius = AppDimensions.radiusLarge,
  });

  final double height;
  final double? width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class ShimmerPropertyCard extends StatelessWidget {
  const ShimmerPropertyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: AppDimensions.propertyCardImageHeight,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppDimensions.radiusLarge),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: AppDimensions.spacing14,
                    width: double.infinity,
                    color: AppColors.white,
                  ),
                  const SizedBox(height: AppDimensions.spacing8),
                  Container(
                    height: AppDimensions.spacing12,
                    width: AppDimensions.spacing96 + AppDimensions.spacing32,
                    color: AppColors.white,
                  ),
                  const SizedBox(height: AppDimensions.spacing8),
                  Container(
                    height: AppDimensions.spacing14,
                    width: AppDimensions.spacing80,
                    color: AppColors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({super.key, this.height = 80});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
      ),
    );
  }
}

class ShimmerPropertyDetail extends StatelessWidget {
  const ShimmerPropertyDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 280, color: AppColors.white),
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.all(AppDimensions.spacing20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                        height: 26,
                        width: 80,
                        decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(
                                AppDimensions.radiusFull))),
                    const SizedBox(width: AppDimensions.spacing8),
                    Container(
                        height: 26,
                        width: 60,
                        decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(
                                AppDimensions.radiusFull))),
                  ]),
                  const SizedBox(height: AppDimensions.spacing12),
                  Container(height: 22, width: double.infinity, color: AppColors.shimmerBase),
                  const SizedBox(height: AppDimensions.spacing8),
                  Container(height: 22, width: 200, color: AppColors.shimmerBase),
                  const SizedBox(height: AppDimensions.spacing12),
                  Container(height: 18, width: 150, color: AppColors.shimmerBase),
                  const SizedBox(height: AppDimensions.spacing12),
                  Container(height: 1, color: AppColors.shimmerBase),
                  const SizedBox(height: AppDimensions.spacing16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      3,
                      (_) => Column(children: [
                        Container(height: 40, width: 40, decoration: BoxDecoration(color: AppColors.shimmerBase, borderRadius: BorderRadius.circular(AppDimensions.radiusMedium))),
                        const SizedBox(height: AppDimensions.spacing6),
                        Container(height: 12, width: 50, color: AppColors.shimmerBase),
                      ]),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  Container(height: 1, color: AppColors.shimmerBase),
                  const SizedBox(height: AppDimensions.spacing16),
                  Container(height: 14, width: 100, color: AppColors.shimmerBase),
                  const SizedBox(height: AppDimensions.spacing10),
                  Container(height: 14, width: double.infinity, color: AppColors.shimmerBase),
                  const SizedBox(height: AppDimensions.spacing6),
                  Container(height: 14, width: double.infinity, color: AppColors.shimmerBase),
                  const SizedBox(height: AppDimensions.spacing6),
                  Container(height: 14, width: 220, color: AppColors.shimmerBase),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerBookingDetail extends StatelessWidget {
  const ShimmerBookingDetail({super.key});

  Widget _block(double h, double w) => Container(
        height: h,
        width: w,
        decoration: BoxDecoration(
          color: AppColors.shimmerBase,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppDimensions.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacing16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    _block(14, 80),
                    _block(26, 90),
                  ]),
                  const SizedBox(height: AppDimensions.spacing8),
                  _block(20, 180),
                  const SizedBox(height: AppDimensions.spacing16),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    _block(14, 120), _block(14, 100),
                  ]),
                  const SizedBox(height: AppDimensions.spacing10),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    _block(14, 100), _block(14, 110),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacing16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              ),
              child: Row(children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: AppColors.shimmerBase,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _block(16, double.infinity),
                    const SizedBox(height: AppDimensions.spacing8),
                    _block(14, 120),
                    const SizedBox(height: AppDimensions.spacing8),
                    _block(14, 90),
                  ],
                )),
              ]),
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacing16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              ),
              child: Column(
                children: List.generate(3, (_) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.spacing12),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    _block(14, 100), _block(14, 120),
                  ]),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerProfile extends StatelessWidget {
  const ShimmerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: AppDimensions.spacing24),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: AppColors.shimmerBase,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing12),
                  Container(height: 20, width: 160, decoration: BoxDecoration(color: AppColors.shimmerBase, borderRadius: BorderRadius.circular(AppDimensions.radiusSmall))),
                  const SizedBox(height: AppDimensions.spacing8),
                  Container(height: 14, width: 200, decoration: BoxDecoration(color: AppColors.shimmerBase, borderRadius: BorderRadius.circular(AppDimensions.radiusSmall))),
                  const SizedBox(height: AppDimensions.spacing8),
                  Container(height: 24, width: 80, decoration: BoxDecoration(color: AppColors.shimmerBase, borderRadius: BorderRadius.circular(AppDimensions.radiusFull))),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacing24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
              child: Column(
                children: List.generate(6, (i) => Container(
                  margin: const EdgeInsets.only(bottom: AppDimensions.spacing12),
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
