class ApiConstants {
  ApiConstants._();

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Auth
  static const String register = '/api/v1/auth/register';
  static const String login = '/api/v1/auth/login';
  static const String refresh = '/api/v1/auth/refresh';
  static const String logout = '/api/v1/auth/logout';
  static const String me = '/api/v1/users/me';

  // Properties
  static const String properties = '/api/v1/properties';
  static const String myProperties = '/api/v1/properties/my';
  static String propertyById(String id) => '/api/v1/properties/$id';

  // Bookings
  static const String bookings = '/api/v1/bookings';
  static String bookingById(String id) => '/api/v1/bookings/$id';
  static String cancelBooking(String id) => '/api/v1/bookings/$id/cancel';

  // Payments
  static const String paymentConfig = '/api/v1/payments/config';
  static const String initializePayment = '/api/v1/payments/initialize';
  static String verifyPayment(String reference) =>
      '/api/v1/payments/verify/$reference';
  static const String paymentHistory = '/api/v1/payments/history';

  // Uploads
  static String propertyImages(String id) => '/api/v1/properties/$id/images';

  // Health
  static const String health = '/health';
}
