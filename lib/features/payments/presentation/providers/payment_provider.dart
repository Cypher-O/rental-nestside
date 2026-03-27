import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/payment_remote_data_source.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../domain/repositories/payment_repository.dart';
import '../viewmodels/payment_state.dart';
import '../viewmodels/payment_viewmodel.dart';
import '../../../../app/flavors.dart';
import '../../../../core/di/service_locator.dart';

final paymentRemoteDataSourceProvider =
    Provider<PaymentRemoteDataSource>((ref) {
  return PaymentRemoteDataSourceImpl(ref.read(apiClientProvider));
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepositoryImpl(ref.read(paymentRemoteDataSourceProvider));
});

final paymentHistoryViewModelProvider =
    StateNotifierProvider<PaymentHistoryViewModel, PaymentHistoryState>(
        (ref) {
  return PaymentHistoryViewModel(ref.read(paymentRepositoryProvider));
});

final paymentInitViewModelProvider =
    StateNotifierProvider<PaymentInitViewModel, PaymentInitState>((ref) {
  return PaymentInitViewModel(ref.read(paymentRepositoryProvider), ref);
});

/// Fetches the Paystack public key from the API.
/// Falls back to the value from .env if the request fails.
final paystackPublicKeyProvider = FutureProvider<String>((ref) async {
  final repo = ref.read(paymentRepositoryProvider);
  final result = await repo.fetchPaymentConfig();
  if (result.isSuccess && result.data!.isNotEmpty) {
    return result.data!;
  }
  return FlavorConfig.shared.paystackPublicKey;
});
