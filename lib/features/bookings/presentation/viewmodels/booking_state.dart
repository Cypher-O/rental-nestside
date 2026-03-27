import '../../domain/entities/booking_entity.dart';
import '../../../../core/enums/app_enums.dart';

class BookingListState {
  const BookingListState({
    this.status = BookingListStatus.initial,
    this.bookings = const [],
    this.errorMessage,
  });

  final BookingListStatus status;
  final List<BookingEntity> bookings;
  final String? errorMessage;

  BookingListState copyWith({
    BookingListStatus? status,
    List<BookingEntity>? bookings,
    String? errorMessage,
  }) {
    return BookingListState(
      status: status ?? this.status,
      bookings: bookings ?? this.bookings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isLoading => status == BookingListStatus.loading;
  bool get isSuccess => status == BookingListStatus.success;
  bool get isFailure => status == BookingListStatus.failure;
}

class BookingDetailState {
  const BookingDetailState({
    this.status = BookingListStatus.initial,
    this.booking,
    this.errorMessage,
    this.isCancelling = false,
    this.isCreating = false,
  });

  final BookingListStatus status;
  final BookingEntity? booking;
  final String? errorMessage;
  final bool isCancelling;
  final bool isCreating;

  BookingDetailState copyWith({
    BookingListStatus? status,
    BookingEntity? booking,
    String? errorMessage,
    bool? isCancelling,
    bool? isCreating,
  }) {
    return BookingDetailState(
      status: status ?? this.status,
      booking: booking ?? this.booking,
      errorMessage: errorMessage ?? this.errorMessage,
      isCancelling: isCancelling ?? this.isCancelling,
      isCreating: isCreating ?? this.isCreating,
    );
  }

  bool get isLoading => status == BookingListStatus.loading;
  bool get isSuccess => status == BookingListStatus.success;
  bool get isFailure => status == BookingListStatus.failure;
}
