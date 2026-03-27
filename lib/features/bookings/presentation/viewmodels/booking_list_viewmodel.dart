import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../../../core/enums/app_enums.dart';
import 'booking_state.dart';

class BookingListViewModel extends StateNotifier<BookingListState> {
  BookingListViewModel(this._repository) : super(const BookingListState());

  final BookingRepository _repository;

  Future<void> loadBookings({bool refresh = false}) async {
    state = state.copyWith(
      status: BookingListStatus.loading,
      bookings: refresh ? [] : state.bookings,
    );

    final result = await _repository.getMyBookings();

    if (result.isSuccess) {
      state = state.copyWith(
        status: BookingListStatus.success,
        bookings: result.data ?? [],
      );
    } else {
      state = state.copyWith(
        status: BookingListStatus.failure,
        errorMessage: result.errorOrEmpty,
      );
    }
  }
}
