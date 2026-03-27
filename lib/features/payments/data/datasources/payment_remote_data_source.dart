import '../../../../core/network/api_client.dart';
import '../../../../core/network/result.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<Result<InitPaymentModel>> initializePayment(
      Map<String, dynamic> data);
  Future<Result<PaymentModel>> verifyPayment(String reference);
  Future<Result<List<PaymentModel>>> getPaymentHistory();
  Future<Result<List<PaymentModel>>> getLandlordPayments();
  Future<Result<String>> fetchPaymentConfig();
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  PaymentRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Result<InitPaymentModel>> initializePayment(
      Map<String, dynamic> data) {
    return _apiClient.post<InitPaymentModel>(
      endpoint: ApiConstants.initializePayment,
      data: data,
      parser: (d) =>
          InitPaymentModel.fromJson(d as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<PaymentModel>> verifyPayment(String reference) {
    return _apiClient.get<PaymentModel>(
      endpoint: ApiConstants.verifyPayment(reference),
      parser: (d) => PaymentModel.fromJson(d as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<String>> fetchPaymentConfig() async {
    final result = await _apiClient.get<String>(
      endpoint: ApiConstants.paymentConfig,
      parser: (data) {
        final d = data is Map ? data : {};
        return d['public_key'] as String? ?? '';
      },
    );
    return result;
  }

  @override
  Future<Result<List<PaymentModel>>> getLandlordPayments() {
    return _apiClient.get<List<PaymentModel>>(
      endpoint: ApiConstants.landlordPayments,
      parser: (d) {
        final list = d is List
            ? d
            : (d is Map ? d['items'] ?? d['payments'] ?? [] : []);
        return (list as List)
            .map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<Result<List<PaymentModel>>> getPaymentHistory() {
    return _apiClient.get<List<PaymentModel>>(
      endpoint: ApiConstants.paymentHistory,
      parser: (d) {
        final list = d is List
            ? d
            : (d is Map ? d['items'] ?? d['payments'] ?? [] : []);
        return (list as List)
            .map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
