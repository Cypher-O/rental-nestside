import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../enums/app_enums.dart';
import '../theme/app_colors.dart';

class BookingStatusBadge extends StatelessWidget {
  const BookingStatusBadge({super.key, required this.status});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, bgColor, label, icon) = _statusConfig();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color, String, IconData) _statusConfig() {
    switch (status) {
      case BookingStatus.pendingPayment:
        return (AppColors.warning, AppColors.warningLight, 'Pending', Icons.schedule_rounded);
      case BookingStatus.confirmed:
        return (AppColors.success, AppColors.successLight, 'Confirmed', Icons.check_circle_outline);
      case BookingStatus.cancelled:
        return (AppColors.error, AppColors.errorLight, 'Cancelled', Icons.cancel_outlined);
      case BookingStatus.completed:
        return (AppColors.textSecondary, AppColors.inputBackground, 'Completed', Icons.done_all_rounded);
    }
  }
}
