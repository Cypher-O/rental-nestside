import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../../../core/enums/app_enums.dart';
import '../providers/booking_provider.dart';
import 'booking_state.dart';

class BookingDetailViewModel extends StateNotifier<BookingDetailState> {
  BookingDetailViewModel(this._repository, this._ref) : super(const BookingDetailState());

  final BookingRepository _repository;
  final Ref _ref;

  Future<void> loadBooking(String id) async {
    state = state.copyWith(status: BookingListStatus.loading);

    final result = await _repository.getBookingById(id);

    if (result.isSuccess) {
      state = state.copyWith(
        status: BookingListStatus.success,
        booking: result.data,
      );
    } else {
      state = state.copyWith(
        status: BookingListStatus.failure,
        errorMessage: result.errorOrEmpty,
      );
    }
  }

  Future<bool> createBooking({
    required String propertyId,
    required String checkIn,
    required String checkOut,
    required int guests,
    String? notes,
  }) async {
    state = state.copyWith(isCreating: true);

    final result = await _repository.createBooking(
      propertyId: propertyId,
      checkIn: checkIn,
      checkOut: checkOut,
      guests: guests,
      notes: notes,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        isCreating: false,
        status: BookingListStatus.success,
        booking: result.data,
      );
      _ref.invalidate(bookingListViewModelProvider);
      return true;
    } else {
      state = state.copyWith(
        isCreating: false,
        status: BookingListStatus.failure,
        errorMessage: result.errorOrEmpty,
      );
      return false;
    }
  }

  Future<bool> cancelBooking(String id) async {
    state = state.copyWith(isCancelling: true);

    final result = await _repository.cancelBooking(id);

    if (result.isSuccess) {
      state = state.copyWith(
        isCancelling: false,
        booking: result.data,
      );
      _ref.invalidate(bookingListViewModelProvider);
      return true;
    } else {
      state = state.copyWith(
        isCancelling: false,
        errorMessage: result.errorOrEmpty,
      );
      return false;
    }
  }
}
