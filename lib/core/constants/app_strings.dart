class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'RentEase';
  static const String tagline = 'Find your perfect rental';

  // Auth
  static const String signIn = 'Sign In';
  static const String signInTitle = 'Welcome back!';
  static const String signInSubtitle = 'Sign in to continue to RentEase';
  static const String signInButton = 'Sign In';
  static const String signUp = 'Sign Up';
  static const String signUpTitle = 'Create Account';
  static const String signUpSubtitle = 'Join thousands of renters and landlords';
  static const String signUpButton = 'Create Account';
  static const String email = 'Email';
  static const String emailHint = 'Enter your email address';
  static const String password = 'Password';
  static const String passwordHint = 'Enter your password';
  static const String firstName = 'First Name';
  static const String firstNameHint = 'Enter your first name';
  static const String lastName = 'Last Name';
  static const String lastNameHint = 'Enter your last name';
  static const String phone = 'Phone Number';
  static const String phoneHint = '08012345678 or +2348012345678';
  static const String role = 'I am a';
  static const String tenant = 'Tenant';
  static const String landlord = 'Landlord';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String signInLink = 'Sign In';
  static const String signUpLink = 'Sign Up';
  static const String logout = 'Log Out';
  static const String logoutConfirmTitle = 'Log Out';
  static const String logoutConfirmMessage = 'Are you sure you want to log out?';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';

  // Home / Properties
  static const String home = 'Home';
  static const String discoverRentals = 'Discover Rentals';
  static const String searchHint = 'Search by city or state...';
  static const String filterBy = 'Filter by type';
  static const String all = 'All';
  static const String apartment = 'Apartment';
  static const String house = 'House';
  static const String room = 'Room';
  static const String studio = 'Studio';
  static const String noPropertiesFound = 'No properties found';
  static const String noPropertiesMessage =
      'Try adjusting your filters or search a different location.';
  static const String clearFilters = 'Clear Filters';
  static const String perNight = '/night';
  static const String bedrooms = 'bedrooms';
  static const String bathrooms = 'bathrooms';
  static const String bedroom = 'bedroom';
  static const String bathroom = 'bathroom';
  static const String guests = 'guests';
  static const String available = 'Available';
  static const String unavailable = 'Unavailable';
  static const String viewDetails = 'View Details';
  static const String addProperty = 'Add Property';

  // Property Detail
  static const String propertyDetails = 'Property Details';
  static const String amenities = 'Amenities';
  static const String location = 'Location';
  static const String about = 'About this property';
  static const String bookNow = 'Book Now';
  static const String editProperty = 'Edit Property';
  static const String deleteProperty = 'Delete Property';
  static const String deletePropertyConfirm =
      'Are you sure you want to delete this property?';
  static const String delete = 'Delete';

  // Create Property
  static const String createProperty = 'Create Listing';
  static const String editPropertyTitle = 'Edit Listing';
  static const String propertyTitle = 'Property Title';
  static const String propertyTitleHint = 'e.g. Modern 2BR flat in Lekki';
  static const String description = 'Description';
  static const String descriptionHint = 'Describe your property...';
  static const String address = 'Address';
  static const String addressHint = 'Street address';
  static const String city = 'City';
  static const String cityHint = 'e.g. Lagos';
  static const String state = 'State';
  static const String stateHint = 'e.g. Lagos';
  static const String country = 'Country';
  static const String countryDefault = 'Nigeria';
  static const String pricePerDay = 'Price per Night (\u20a6)';
  static const String pricePerDayHint = 'e.g. 25000';
  static const String propertyType = 'Property Type';
  static const String bedroomsLabel = 'Bedrooms';
  static const String bathroomsLabel = 'Bathrooms';
  static const String maxGuests = 'Max Guests';
  static const String amenitiesLabel = 'Amenities (comma separated)';
  static const String amenitiesHint = 'WiFi, Air Conditioning, Generator';
  static const String imageUrls = 'Image URLs (comma separated)';
  static const String imageUrlsHint = 'https://example.com/image1.jpg, ...';
  static const String saveListing = 'Save Listing';
  static const String updateListing = 'Update Listing';

  // My Listings
  static const String myListings = 'My Listings';
  static const String noListings = 'No listings yet';
  static const String noListingsMessage =
      'Start earning by listing your property.';
  static const String createFirstListing = 'Create Listing';

  // Bookings
  static const String bookings = 'Bookings';
  static const String myBookings = 'My Bookings';
  static const String noBookings = 'No bookings yet';
  static const String noBookingsMessage =
      'Your booking history will appear here.';
  static const String bookingDetails = 'Booking Details';
  static const String checkIn = 'Check-in';
  static const String checkOut = 'Check-out';
  static const String guestsLabel = 'Guests';
  static const String notes = 'Notes (optional)';
  static const String notesHint = 'Any special requests?';
  static const String totalAmount = 'Total';
  static const String nights = 'nights';
  static const String night = 'night';
  static const String confirmBooking = 'Confirm Booking';
  static const String cancelBooking = 'Cancel Booking';
  static const String cancelBookingConfirm =
      'Are you sure you want to cancel this booking?';
  static const String payNow = 'Pay Now';
  static const String bookingCreated = 'Booking created. Proceed to payment.';

  // Booking status
  static const String statusPendingPayment = 'Pending Payment';
  static const String statusConfirmed = 'Confirmed';
  static const String statusCancelled = 'Cancelled';
  static const String statusCompleted = 'Completed';

  // Payments
  static const String payments = 'Payments';
  static const String paymentHistory = 'Payment History';
  static const String noPayments = 'No payments yet';
  static const String noPaymentsMessage =
      'Your payment history will appear here.';
  static const String initializingPayment = 'Initializing payment...';
  static const String openingPaymentPage = 'Opening payment page...';
  static const String verifyingPayment = 'Verifying payment...';
  static const String paymentSuccessful = 'Payment Successful!';
  static const String bookingConfirmed =
      'Your booking has been confirmed. Enjoy your stay!';
  static const String paymentFailed = 'Payment Failed';
  static const String completePayment = 'Complete Your Payment';
  static const String completePaymentMessage =
      "Your payment page has been opened. Complete the payment in your browser, then tap \"I've Paid\" to confirm.";
  static const String ivesPaid = "I've Paid";
  static const String reopenPaymentPage = 'Reopen Payment Page';
  static const String tryAgain = 'Try Again';
  static const String goBack = 'Go Back';
  static const String viewMyBookings = 'View My Bookings';

  // Profile
  static const String profile = 'Profile';
  static const String editProfile = 'Edit Profile';
  static const String myAccount = 'My Account';
  static const String verified = 'Verified';
  static const String notVerified = 'Not Verified';

  // Auth — extra
  static const String confirmPassword = 'Confirm Password';
  static const String confirmPasswordHint = 'Repeat your password';
  static const String passwordMinHint = 'Min 6 characters';
  static const String accountCreated = 'Account created! Please sign in.';
  static const String loginFailed = 'Login failed';
  static const String registrationFailed = 'Registration failed';
  static const String editProfileComingSoon = 'Edit profile coming soon';

  // Booking — extra
  static const String bookingCancelledSuccess = 'Booking cancelled successfully';
  static const String bookingCancelFailed = 'Failed to cancel booking';
  static const String bookingCreatedSuccess = 'Booking created successfully!';
  static const String selectCheckInFirst = 'Please select check-in date first';
  static const String selectDates = 'Please select check-in and check-out dates';
  static const String checkOutAfterCheckIn = 'Check-out must be after check-in';
  static const String cancelling = 'Cancelling…';
  static const String bookingId = 'Booking ID';
  static const String paymentRef = 'Payment Reference';
  static const String stayDetails = 'Stay Details';
  static const String paymentSummary = 'Payment Summary';

  // Property — extra
  static const String propertyCreatedSuccess = 'Property created successfully';
  static const String propertyUpdatedSuccess = 'Property updated successfully';
  static const String propertyDeletedSuccess = 'Property deleted';
  static const String operationFailed = 'Operation failed';

  // Section titles
  static const String sectionBasicInfo = 'Basic Information';
  static const String sectionPricingCapacity = 'Pricing & Capacity';
  static const String sectionImages = 'Images';

  // Card Payment
  static const String payWithCard = 'Pay with Card';
  static const String cardNumber = 'Card Number';
  static const String expiryDate = 'Expiry Date';
  static const String cvv = 'CVV';
  static const String cardholderName = 'Cardholder Name';
  static const String securePayment = 'Secured by Paystack';
  static const String cardNumberHint = '0000 0000 0000 0000';
  static const String expiryHint = 'MM/YY';
  static const String cvvHint = '•••';
  static const String cardholderNameHint = 'JOHN DOE';

  // Common
  static const String hello = 'Hello';
  static const String retry = 'Retry';
  static const String loading = 'Loading...';
  static const String somethingWentWrong = 'Something went wrong';
  static const String tryAgainLater = 'Please try again later.';
  static const String save = 'Save';
  static const String done = 'Done';
  static const String next = 'Next';
  static const String back = 'Back';
  static const String close = 'Close';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String currency = '\u20a6';
  static const String viewAll = 'View All';
  static const String featureComingSoon = 'This feature is coming soon';
}
