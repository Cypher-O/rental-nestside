import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class PropertyListHeader extends StatelessWidget {
  const PropertyListHeader({
    super.key,
    this.userName,
    required this.searchController,
    required this.onSearch,
    required this.onClearSearch,
    this.onListingsPressed,
    this.showListingsButton = false,
  });

  final String? userName;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final VoidCallback onClearSearch;
  final VoidCallback? onListingsPressed;
  final bool showListingsButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F1F35), Color(0xFF1E3A5F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 16,
      ),
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
                      userName != null
                          ? 'Hello, $userName! 👋'
                          : 'Discover Rentals',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Find your perfect home today',
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        color: AppColors.white.withAlpha(160),
                      ),
                    ),
                  ],
                ),
              ),
              if (showListingsButton && onListingsPressed != null)
                GestureDetector(
                  onTap: onListingsPressed,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.list_alt_rounded,
                            color: AppColors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'My Listings',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _PremiumSearchBar(
            controller: searchController,
            onSearch: onSearch,
            onClear: onClearSearch,
          ),
        ],
      ),
    );
  }
}

class _PremiumSearchBar extends StatelessWidget {
  const _PremiumSearchBar({
    required this.controller,
    required this.onSearch,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSearch;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Icon(
              Icons.search_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search by city or location...',
                hintStyle: GoogleFonts.poppins(
                  color: AppColors.textLight,
                  fontSize: 13.5,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              onSubmitted: onSearch,
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: onClear,
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close_rounded,
                    size: 14, color: AppColors.textSecondary),
              ),
            ),
        ],
      ),
    );
  }
}
