import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../bookings/presentation/providers/booking_provider.dart';
import '../providers/payment_provider.dart';
import 'payment_state.dart';

class PaymentHistoryViewModel
    extends StateNotifier<PaymentHistoryState> {
  PaymentHistoryViewModel(this._repository)
      : super(const PaymentHistoryState());

  final PaymentRepository _repository;

  Future<void> loadHistory({bool refresh = false}) async {
    state = state.copyWith(status: PaymentInitStatus.loading);

    final result = await _repository.getPaymentHistory();

    if (result.isSuccess) {
      state = state.copyWith(
        status: PaymentInitStatus.success,
        payments: result.data ?? [],
      );
    } else {
      state = state.copyWith(
        status: PaymentInitStatus.failure,
        errorMessage: result.errorOrEmpty,
      );
    }
  }
}

class PaymentInitViewModel extends StateNotifier<PaymentInitState> {
  PaymentInitViewModel(this._repository, this._ref) : super(const PaymentInitState());

  final PaymentRepository _repository;
  final Ref _ref;

  Future<bool> initializePayment({
    required String bookingId,
    required String email,
    String callbackUrl = '',
  }) async {
    state = state.copyWith(status: PaymentInitStatus.loading);

    final result = await _repository.initializePayment(
      bookingId: bookingId,
      email: email,
      callbackUrl: callbackUrl,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        status: PaymentInitStatus.success,
        initPayment: result.data,
      );
      return true;
    } else {
      state = state.copyWith(
        status: PaymentInitStatus.failure,
        errorMessage: result.errorOrEmpty,
      );
      return false;
    }
  }

  Future<bool> verifyPayment(String reference) async {
    state = state.copyWith(status: PaymentInitStatus.loading);

    final result = await _repository.verifyPayment(reference);

    if (result.isSuccess) {
      state = state.copyWith(
        status: PaymentInitStatus.success,
        verifiedPayment: result.data,
      );
      _ref.invalidate(paymentHistoryViewModelProvider);
      _ref.invalidate(bookingListViewModelProvider);
      return true;
    } else {
      state = state.copyWith(
        status: PaymentInitStatus.failure,
        errorMessage: result.errorOrEmpty,
      );
      return false;
    }
  }
}
