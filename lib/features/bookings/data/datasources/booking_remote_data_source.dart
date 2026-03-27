import '../../../../core/network/api_client.dart';
import '../../../../core/network/result.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<Result<BookingModel>> createBooking(Map<String, dynamic> data);
  Future<Result<List<BookingModel>>> getMyBookings();
  Future<Result<List<BookingModel>>> getLandlordBookings();
  Future<Result<BookingModel>> getBookingById(String id);
  Future<Result<BookingModel>> cancelBooking(String id);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  BookingRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Result<BookingModel>> createBooking(Map<String, dynamic> data) {
    return _apiClient.post<BookingModel>(
      endpoint: ApiConstants.bookings,
      data: data,
      parser: (d) => BookingModel.fromJson(d as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<List<BookingModel>>> getMyBookings() {
    return _apiClient.get<List<BookingModel>>(
      endpoint: ApiConstants.bookings,
      parser: (d) {
        final list = d is List
            ? d
            : (d is Map ? d['items'] ?? d['bookings'] ?? [] : []);
        return (list as List)
            .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<Result<List<BookingModel>>> getLandlordBookings() {
    return _apiClient.get<List<BookingModel>>(
      endpoint: ApiConstants.landlordBookings,
      parser: (d) {
        final list = d is List
            ? d
            : (d is Map ? d['items'] ?? d['bookings'] ?? [] : []);
        return (list as List)
            .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<Result<BookingModel>> getBookingById(String id) {
    return _apiClient.get<BookingModel>(
      endpoint: ApiConstants.bookingById(id),
      parser: (d) => BookingModel.fromJson(d as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<BookingModel>> cancelBooking(String id) {
    return _apiClient.put<BookingModel>(
      endpoint: ApiConstants.cancelBooking(id),
      parser: (d) => BookingModel.fromJson(d as Map<String, dynamic>),
    );
  }
}
