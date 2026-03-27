import '../../domain/entities/payment_entity.dart';
import '../../../../core/enums/app_enums.dart';

class PaymentModel {
  const PaymentModel({
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

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String? ?? '',
      bookingId: json['booking_id'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'NGN',
      reference: json['reference'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      channel: json['channel'] as String?,
      paidAt: json['paid_at'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  final String id;
  final String bookingId;
  final double amount;
  final String currency;
  final String reference;
  final String status;
  final String? channel;
  final String? paidAt;
  final String? createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'booking_id': bookingId,
        'amount': amount,
        'currency': currency,
        'reference': reference,
        'status': status,
        'channel': channel,
        'paid_at': paidAt,
        'created_at': createdAt,
      };

  PaymentEntity toEntity() => PaymentEntity(
        id: id,
        bookingId: bookingId,
        amount: amount,
        currency: currency,
        reference: reference,
        status: PaymentStatusX.fromString(status),
        channel: channel,
        paidAt: paidAt,
        createdAt: createdAt,
      );
}

class InitPaymentModel {
  const InitPaymentModel({
    required this.reference,
    required this.authorizationUrl,
    required this.accessCode,
  });

  factory InitPaymentModel.fromJson(Map<String, dynamic> json) {
    return InitPaymentModel(
      reference: json['reference'] as String? ?? '',
      authorizationUrl: json['authorization_url'] as String? ?? '',
      accessCode: json['access_code'] as String? ?? '',
    );
  }

  final String reference;
  final String authorizationUrl;
  final String accessCode;

  InitPaymentEntity toEntity() => InitPaymentEntity(
        reference: reference,
        authorizationUrl: authorizationUrl,
        accessCode: accessCode,
      );
}
