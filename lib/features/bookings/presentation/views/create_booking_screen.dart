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
import '../../../../core/widgets/inputs/text_input.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../providers/booking_provider.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/guest_counter.dart';
import '../widgets/price_summary.dart';
import '../../../properties/presentation/providers/property_provider.dart';

class CreateBookingScreen extends ConsumerStatefulWidget {
  const CreateBookingScreen({super.key, required this.propertyId});

  final String propertyId;

  @override
  ConsumerState<CreateBookingScreen> createState() =>
      _CreateBookingScreenState();
}

class _CreateBookingScreenState extends ConsumerState<CreateBookingScreen> {
  final _notesController = TextEditingController();
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _guests = 1;

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
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  int get _nights {
    if (_checkIn == null || _checkOut == null) return 0;
    return _checkOut!.difference(_checkIn!).inDays;
  }

  double get _totalAmount {
    final property = ref.read(propertyDetailViewModelProvider).property;
    if (property == null || _nights <= 0) return 0;
    return property.pricePerDay * _nights;
  }

  Future<void> _pickCheckIn() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkIn ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _checkIn = picked;
        if (_checkOut != null && _checkOut!.isBefore(picked)) {
          _checkOut = null;
        }
      });
    }
  }

  Future<void> _pickCheckOut() async {
    if (_checkIn == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: AppText(AppStrings.selectCheckInFirst)),
      );
      return;
    }
    final minDate = _checkIn!.add(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkOut ?? minDate,
      firstDate: minDate,
      lastDate: _checkIn!.add(const Duration(days: 90)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _checkOut = picked);
    }
  }

  Future<void> _submit() async {
    if (_checkIn == null || _checkOut == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(AppStrings.selectDates),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_nights <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(AppStrings.checkOutAfterCheckIn),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final success = await ref
        .read(bookingDetailViewModelProvider.notifier)
        .createBooking(
          propertyId: widget.propertyId,
          checkIn: '${_checkIn!.toIso8601String().split('T').first}T00:00:00Z',
          checkOut: '${_checkOut!.toIso8601String().split('T').first}T00:00:00Z',
          guests: _guests,
          notes: _notesController.text.trim().isNotEmpty
              ? _notesController.text.trim()
              : null,
        );

    if (!mounted) return;

    if (success) {
      final booking = ref.read(bookingDetailViewModelProvider).booking;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(AppStrings.bookingCreatedSuccess),
          backgroundColor: AppColors.success,
        ),
      );
      if (booking != null) {
        context.go(AppRoutes.bookingDetailPath(booking.id));
      } else {
        context.go(AppRoutes.bookings);
      }
    } else {
      final error =
          ref.read(bookingDetailViewModelProvider).errorMessage ??
              AppStrings.operationFailed;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: AppText(error), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final propertyState = ref.watch(propertyDetailViewModelProvider);
    final isCreating = ref.watch(bookingDetailViewModelProvider).isCreating;
    final property = propertyState.property;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppHeader(
        title: 'Book Property',
        onBackPressed: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (property != null) ...[
              Container(
                padding: const EdgeInsets.all(AppDimensions.cardPadding),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.cardRadius - AppDimensions.spacing2,
                  ),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: AppDimensions.spacing56,
                      height: AppDimensions.spacing56,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(15),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.spacing10),
                      ),
                      child: const Icon(
                        Icons.home_outlined,
                        color: AppColors.primary,
                        size: AppDimensions.spacing28,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacing12),
                    Expanded(
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
                          AppText(
                            property.locationSummary,
                            fontSize: AppTypography.fontSize12,
                            color: AppColors.textSecondary,
                          ),
                          AppText(
                            CurrencyFormatter.formatPerNight(property.pricePerDay),
                            fontSize: AppTypography.fontSize13,
                            fontWeight: AppTypography.weightBold,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacing24),
            ],
            AppText(
              'Select Dates',
              fontSize: AppTypography.fontSize16,
              fontWeight: AppTypography.weightBold,
              color: AppColors.textPrimary,
            ),
            const SizedBox(height: AppDimensions.spacing12),
            Row(
              children: [
                Expanded(
                  child: DatePickerField(
                    label: AppStrings.checkIn,
                    date: _checkIn,
                    onTap: _pickCheckIn,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: DatePickerField(
                    label: AppStrings.checkOut,
                    date: _checkOut,
                    onTap: _pickCheckOut,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing24),
            AppText(
              'Number of Guests',
              fontSize: AppTypography.fontSize16,
              fontWeight: AppTypography.weightBold,
              color: AppColors.textPrimary,
            ),
            const SizedBox(height: AppDimensions.spacing12),
            GuestCounter(
              value: _guests,
              maxGuests: property?.maxGuests,
              onDecrement: _guests > 1
                  ? () => setState(() => _guests--)
                  : null,
              onIncrement:
                  (property == null || _guests < property.maxGuests)
                      ? () => setState(() => _guests++)
                      : null,
            ),
            const SizedBox(height: AppDimensions.spacing24),
            AppText(
              AppStrings.notes,
              fontSize: AppTypography.fontSize16,
              fontWeight: AppTypography.weightBold,
              color: AppColors.textPrimary,
            ),
            const SizedBox(height: AppDimensions.spacing12),
            TextInput(
              controller: _notesController,
              label: 'Special requests or notes',
              hint: AppStrings.notesHint,
              maxLines: 3,
            ),
            if (_nights > 0 && property != null) ...[
              const SizedBox(height: AppDimensions.spacing24),
              PriceSummary(
                pricePerNight: property.pricePerDay,
                nights: _nights,
                totalAmount: _totalAmount,
              ),
            ],
            const SizedBox(height: AppDimensions.spacing32),
            CustomButton.secondary(
              text: AppStrings.confirmBooking,
              onPressed: _submit,
              isLoading: isCreating,
            ),
            const SizedBox(height: AppDimensions.spacing40),
          ],
        ),
      ),
    );
  }
}
