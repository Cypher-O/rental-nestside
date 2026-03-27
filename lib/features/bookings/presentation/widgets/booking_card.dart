import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/booking_status_badge.dart';
import '../../../bookings/domain/entities/booking_entity.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.booking,
    this.onTap,
    this.showPropertyInfo = false,
  });

  final BookingEntity booking;
  final VoidCallback? onTap;
  final bool showPropertyInfo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowMedium,
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with gradient
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F1F35), Color(0xFF1E3A5F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.white.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.home_work_outlined,
                      color: AppColors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.propertyTitle ??
                              'Property #${booking.propertyId.substring(0, 8)}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (booking.propertyCity != null ||
                            booking.propertyAddress != null) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 11, color: AppColors.accent),
                              const SizedBox(width: 2),
                              Flexible(
                                child: Text(
                                  showPropertyInfo && booking.propertyAddress != null
                                      ? booking.propertyAddress!
                                      : booking.propertyCity ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: AppColors.white.withAlpha(180),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  BookingStatusBadge(status: booking.status),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _DateBlock(
                    label: 'Check-in',
                    date: _formatDate(booking.checkIn),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.accent,
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${booking.nights} night${booking.nights != 1 ? 's' : ''}',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _DateBlock(
                    label: 'Check-out',
                    date: _formatDate(booking.checkOut),
                    alignRight: true,
                  ),
                ],
              ),
            ),
            // Footer
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          showPropertyInfo
                              ? Icons.person_outline
                              : Icons.people_outline,
                          size: 13,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          showPropertyInfo
                              ? 'Guest ···${booking.tenantId.length >= 6 ? booking.tenantId.substring(booking.tenantId.length - 6) : booking.tenantId}'
                              : '${booking.guests} guest${booking.guests != 1 ? 's' : ''}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        CurrencyFormatter.format(booking.totalAmount),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'Total',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${dt.day} ${months[dt.month - 1]}';
    } catch (_) {
      return dateStr.length > 10 ? dateStr.substring(0, 10) : dateStr;
    }
  }
}

class _DateBlock extends StatelessWidget {
  const _DateBlock({
    required this.label,
    required this.date,
    this.alignRight = false,
  });

  final String label;
  final String date;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          date,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
