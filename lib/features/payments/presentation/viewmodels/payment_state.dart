import '../../domain/entities/payment_entity.dart';
import '../../../../core/enums/app_enums.dart';

class PaymentHistoryState {
  const PaymentHistoryState({
    this.status = PaymentInitStatus.initial,
    this.payments = const [],
    this.errorMessage,
  });

  final PaymentInitStatus status;
  final List<PaymentEntity> payments;
  final String? errorMessage;

  PaymentHistoryState copyWith({
    PaymentInitStatus? status,
    List<PaymentEntity>? payments,
    String? errorMessage,
  }) {
    return PaymentHistoryState(
      status: status ?? this.status,
      payments: payments ?? this.payments,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isLoading => status == PaymentInitStatus.loading;
  bool get isSuccess => status == PaymentInitStatus.success;
  bool get isFailure => status == PaymentInitStatus.failure;
}

class PaymentInitState {
  const PaymentInitState({
    this.status = PaymentInitStatus.initial,
    this.initPayment,
    this.verifiedPayment,
    this.errorMessage,
  });

  final PaymentInitStatus status;
  final InitPaymentEntity? initPayment;
  final PaymentEntity? verifiedPayment;
  final String? errorMessage;

  PaymentInitState copyWith({
    PaymentInitStatus? status,
    InitPaymentEntity? initPayment,
    PaymentEntity? verifiedPayment,
    String? errorMessage,
  }) {
    return PaymentInitState(
      status: status ?? this.status,
      initPayment: initPayment ?? this.initPayment,
      verifiedPayment: verifiedPayment ?? this.verifiedPayment,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isLoading => status == PaymentInitStatus.loading;
  bool get isSuccess => status == PaymentInitStatus.success;
  bool get isFailure => status == PaymentInitStatus.failure;
}
