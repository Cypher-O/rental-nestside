enum AppStatus { loading, authenticated, unauthenticated }

enum UserRole { tenant, landlord, admin }

enum PropertyType { apartment, house, room, studio }

enum BookingStatus { pendingPayment, confirmed, cancelled, completed }

enum PaymentStatus { pending, success, failed, abandoned }

enum AuthStatus { initial, loading, success, failure }

enum PropertyListStatus { initial, loading, success, failure }

enum PropertyDetailStatus { initial, loading, success, failure }

enum BookingListStatus { initial, loading, success, failure }

enum PaymentInitStatus { initial, loading, success, failure }

extension UserRoleX on UserRole {
  String get value {
    switch (this) {
      case UserRole.tenant:
        return 'tenant';
      case UserRole.landlord:
        return 'landlord';
      case UserRole.admin:
        return 'admin';
    }
  }

  static UserRole fromString(String value) {
    switch (value) {
      case 'landlord':
        return UserRole.landlord;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.tenant;
    }
  }
}

extension PropertyTypeX on PropertyType {
  String get value {
    switch (this) {
      case PropertyType.apartment:
        return 'apartment';
      case PropertyType.house:
        return 'house';
      case PropertyType.room:
        return 'room';
      case PropertyType.studio:
        return 'studio';
    }
  }

  static PropertyType fromString(String? value) {
    switch (value) {
      case 'house':
        return PropertyType.house;
      case 'room':
        return PropertyType.room;
      case 'studio':
        return PropertyType.studio;
      default:
        return PropertyType.apartment;
    }
  }
}

extension BookingStatusX on BookingStatus {
  String get value {
    switch (this) {
      case BookingStatus.pendingPayment:
        return 'pending_payment';
      case BookingStatus.confirmed:
        return 'confirmed';
      case BookingStatus.cancelled:
        return 'cancelled';
      case BookingStatus.completed:
        return 'completed';
    }
  }

  static BookingStatus fromString(String? value) {
    switch (value) {
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'completed':
        return BookingStatus.completed;
      default:
        return BookingStatus.pendingPayment;
    }
  }
}

extension PaymentStatusX on PaymentStatus {
  String get value {
    switch (this) {
      case PaymentStatus.pending:
        return 'pending';
      case PaymentStatus.success:
        return 'success';
      case PaymentStatus.failed:
        return 'failed';
      case PaymentStatus.abandoned:
        return 'abandoned';
    }
  }

  static PaymentStatus fromString(String? value) {
    switch (value) {
      case 'success':
        return PaymentStatus.success;
      case 'failed':
        return PaymentStatus.failed;
      case 'abandoned':
        return PaymentStatus.abandoned;
      default:
        return PaymentStatus.pending;
    }
  }
}
