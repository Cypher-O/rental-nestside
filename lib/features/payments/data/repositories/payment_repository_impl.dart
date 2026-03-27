import '../../../../core/network/result.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl(this._remoteDataSource);

  final PaymentRemoteDataSource _remoteDataSource;

  @override
  Future<Result<InitPaymentEntity>> initializePayment({
    required String bookingId,
    required String email,
    required String callbackUrl,
  }) async {
    final result = await _remoteDataSource.initializePayment({
      'booking_id': bookingId,
      'email': email,
      'callback_url':
          callbackUrl.isNotEmpty ? callbackUrl : AppConstants.paystackCallbackScheme,
    });
    if (result.isFailure) return Result.failure(result.errorOrEmpty);
    return Result.success(result.data!.toEntity());
  }

  @override
  Future<Result<PaymentEntity>> verifyPayment(String reference) async {
    final result = await _remoteDataSource.verifyPayment(reference);
    if (result.isFailure) return Result.failure(result.errorOrEmpty);
    return Result.success(result.data!.toEntity());
  }

  @override
  Future<Result<List<PaymentEntity>>> getPaymentHistory() async {
    final result = await _remoteDataSource.getPaymentHistory();
    if (result.isFailure) return Result.failure(result.errorOrEmpty);
    return Result.success(result.data!.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Result<List<PaymentEntity>>> getLandlordPayments() async {
    final result = await _remoteDataSource.getLandlordPayments();
    if (result.isFailure) return Result.failure(result.errorOrEmpty);
    return Result.success(result.data!.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Result<String>> fetchPaymentConfig() {
    return _remoteDataSource.fetchPaymentConfig();
  }
}
