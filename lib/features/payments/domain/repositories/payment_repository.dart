import '../../../../core/network/result.dart';
import '../entities/payment_entity.dart';

abstract class PaymentRepository {
  Future<Result<InitPaymentEntity>> initializePayment({
    required String bookingId,
    required String email,
    required String callbackUrl,
  });

  Future<Result<PaymentEntity>> verifyPayment(String reference);

  Future<Result<List<PaymentEntity>>> getPaymentHistory();
  Future<Result<String>> fetchPaymentConfig();
}
