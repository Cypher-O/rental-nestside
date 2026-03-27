import '../../../../core/enums/app_enums.dart';

class PaymentEntity {
  const PaymentEntity({
    required this.id,
    required this.bookingId,
    required this.amount,
    required this.currency,
    required this.reference,
    required this.status,
    this.channel,
    this.paidAt,
    this.createdAt,
  });

  final String id;
  final String bookingId;
  final double amount;
  final String currency;
  final String reference;
  final PaymentStatus status;
  final String? channel;
  final String? paidAt;
  final String? createdAt;
}

class InitPaymentEntity {
  const InitPaymentEntity({
    required this.reference,
    required this.authorizationUrl,
    required this.accessCode,
  });

  final String reference;
  final String authorizationUrl;
  final String accessCode;
}
