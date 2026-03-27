import '../../../../core/network/result.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl(this._remoteDataSource);

  final BookingRemoteDataSource _remoteDataSource;

  @override
  Future<Result<BookingEntity>> createBooking({
    required String propertyId,
    required String checkIn,
    required String checkOut,
    required int guests,
    String? notes,
  }) async {
    final result = await _remoteDataSource.createBooking({
      'property_id': propertyId,
      'check_in': checkIn,
      'check_out': checkOut,
      'guests': guests,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    });
    if (result.isFailure) return Result.failure(result.errorOrEmpty);
    return Result.success(result.data!.toEntity());
  }

  @override
  Future<Result<List<BookingEntity>>> getMyBookings() async {
    final result = await _remoteDataSource.getMyBookings();
    if (result.isFailure) return Result.failure(result.errorOrEmpty);
    return Result.success(result.data!.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Result<BookingEntity>> getBookingById(String id) async {
    final result = await _remoteDataSource.getBookingById(id);
    if (result.isFailure) return Result.failure(result.errorOrEmpty);
    return Result.success(result.data!.toEntity());
  }

  @override
  Future<Result<BookingEntity>> cancelBooking(String id) async {
    final result = await _remoteDataSource.cancelBooking(id);
    if (result.isFailure) return Result.failure(result.errorOrEmpty);
    return Result.success(result.data!.toEntity());
  }
}
