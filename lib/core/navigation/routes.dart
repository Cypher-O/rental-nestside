class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  // Authenticated Shell
  static const String home = '/home';
  static const String propertyDetail = '/property/:id';
  static const String createProperty = '/property/create';
  static const String editProperty = '/property/:id/edit';
  static const String myListings = '/my-listings';

  static const String bookings = '/bookings';
  static const String bookingDetail = '/bookings/:id';
  static const String createBooking = '/create-booking';

  static const String payments = '/payments';
  static const String paymentProcess = '/payment-process';

  static const String profile = '/profile';

  // Path helpers
  static String propertyDetailPath(String id) => '/property/$id';
  static String editPropertyPath(String id) => '/property/$id/edit';
  static String bookingDetailPath(String id) => '/bookings/$id';
}
