import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class PropertyTypeFilter extends StatelessWidget {
  const PropertyTypeFilter({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  final String? selectedType;
  final ValueChanged<String?> onTypeSelected;

  static const List<(String, String?, IconData)> _types = [
    ('All', null, Icons.grid_view_rounded),
    ('Apartment', 'apartment', Icons.apartment_rounded),
    ('House', 'house', Icons.house_rounded),
    ('Room', 'room', Icons.bed_rounded),
    ('Studio', 'studio', Icons.cabin_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: _types.map((entry) {
          final (label, value, icon) = entry;
          final isAll = value == null;
          final isSelected = isAll ? selectedType == null : selectedType == value;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _FilterPill(
              label: label,
              icon: icon,
              isSelected: isSelected,
              onTap: () => onTypeSelected(value),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.inputBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(60),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? AppColors.accent : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
