import '../../../../core/enums/app_enums.dart';

class BookingEntity {
  const BookingEntity({
    required this.id,
    required this.propertyId,
    required this.tenantId,
    required this.checkIn,
    required this.checkOut,
    required this.nights,
    required this.totalAmount,
    required this.status,
    this.paymentRef,
    required this.guests,
    this.notes,
    this.createdAt,
    this.propertyTitle,
    this.propertyCity,
    this.propertyImage,
  });

  final String id;
  final String propertyId;
  final String tenantId;
  final String checkIn;
  final String checkOut;
  final int nights;
  final double totalAmount;
  final BookingStatus status;
  final String? paymentRef;
  final int guests;
  final String? notes;
  final String? createdAt;
  final String? propertyTitle;
  final String? propertyCity;
  final String? propertyImage;

  bool get canCancel =>
      status == BookingStatus.pendingPayment ||
      status == BookingStatus.confirmed;
  bool get needsPayment => status == BookingStatus.pendingPayment;
}
