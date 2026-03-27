import '../../domain/entities/booking_entity.dart';
import '../../../../core/enums/app_enums.dart';

class BookingModel {
  const BookingModel({
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
    this.propertyAddress,
    this.propertyCity,
    this.propertyImage,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    // Handle nested property object (tenant endpoint) or flat fields (landlord endpoint)
    final property = json['property'] as Map<String, dynamic>?;

    return BookingModel(
      id: json['id'] as String? ?? '',
      propertyId: json['property_id'] as String? ?? property?['id'] as String? ?? '',
      tenantId: json['tenant_id'] as String? ?? '',
      checkIn: json['check_in'] as String? ?? '',
      checkOut: json['check_out'] as String? ?? '',
      nights: json['nights'] as int? ?? 0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'pending_payment',
      paymentRef: json['payment_ref'] as String?,
      guests: json['guests'] as int? ?? 1,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String?,
      // Flat fields take priority (landlord endpoint), fall back to nested property object
      propertyTitle: json['property_title'] as String? ?? property?['title'] as String?,
      propertyAddress: json['property_address'] as String? ?? property?['address'] as String?,
      propertyCity: json['property_city'] as String? ?? property?['city'] as String?,
      propertyImage: (property?['images'] as List<dynamic>?)?.isNotEmpty == true
          ? (property!['images'] as List<dynamic>).first as String
          : null,
    );
  }

  final String id;
  final String propertyId;
  final String tenantId;
  final String checkIn;
  final String checkOut;
  final int nights;
  final double totalAmount;
  final String status;
  final String? paymentRef;
  final int guests;
  final String? notes;
  final String? createdAt;
  final String? propertyTitle;
  final String? propertyAddress;
  final String? propertyCity;
  final String? propertyImage;

  Map<String, dynamic> toJson() => {
        'id': id,
        'property_id': propertyId,
        'tenant_id': tenantId,
        'check_in': checkIn,
        'check_out': checkOut,
        'nights': nights,
        'total_amount': totalAmount,
        'status': status,
        'payment_ref': paymentRef,
        'guests': guests,
        'notes': notes,
        'created_at': createdAt,
      };

  BookingEntity toEntity() => BookingEntity(
        id: id,
        propertyId: propertyId,
        tenantId: tenantId,
        checkIn: checkIn,
        checkOut: checkOut,
        nights: nights,
        totalAmount: totalAmount,
        status: BookingStatusX.fromString(status),
        paymentRef: paymentRef,
        guests: guests,
        notes: notes,
        createdAt: createdAt,
        propertyTitle: propertyTitle,
        propertyAddress: propertyAddress,
        propertyCity: propertyCity,
        propertyImage: propertyImage,
      );
}
