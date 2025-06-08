class ApiConstants {
  static const String baseUrl = 'http://20.74.208.111:5260/';

  // Authentication Endpoints
  static const String login = 'api/Users/Login';
  static const String signup = 'api/Users/Regestriation';
  static const String logout = 'api/Users/Logout';
  static const String resetPassword = 'api/Users/ResetPassword';

  // Destinations Endpoints
  static const String destinations = 'api/Destinations/GetAllDestinations';
  static const String destinationDetails =
      'api/Destinations/GetDestinationDetails';
  static const String destinationsByCategory = 'api/Destinations/GetByCategory';

  // User Profile Endpoints
  static const String userProfile = 'api/Users/GetUserInfo';
  static const String editUserProfile = 'api/Users/EditUserInfo';

  // Bookings Endpoints
  static const String bookings = 'api/bookings';
  static const String bookDestination = 'api/Destinations/Booking';
  static const String unbookDestination = 'api/Destinations/UnBookDestination';
}

class SharedPrefKeys {
  static const String token = 'auth_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String isFirstTime = 'is_first_time';
  static const String language = 'language';
}
