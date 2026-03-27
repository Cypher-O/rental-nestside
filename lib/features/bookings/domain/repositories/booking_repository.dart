import '../../../../core/network/result.dart';
import '../entities/booking_entity.dart';

abstract class BookingRepository {
  Future<Result<BookingEntity>> createBooking({
    required String propertyId,
    required String checkIn,
    required String checkOut,
    required int guests,
    String? notes,
  });

  Future<Result<List<BookingEntity>>> getMyBookings();

  Future<Result<BookingEntity>> getBookingById(String id);

  Future<Result<BookingEntity>> cancelBooking(String id);
}
