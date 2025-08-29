class Endpoints {
  //Authentication
  static const String login = '/api/login';
  static const String register = '/api/signup';
  static const String sendOTP = '/api/otp/send';
  static const String verifyOtp = '/api/otp/verify';
  static const String changePassword = '/api/password/change';
  static const String deleteUser = '/api/user/delete';
  static const String updateUserDetails = '/api/user/details';

  //Domain
  static const String domainSearch = '/api/domains/search';
  static const String domainSuggestions = '/api/domains/suggestions';

  //Cart
  static const String cart = '/api/cart';

  //Orders
  static const String orders = '/api/orders';

  //Payments
  static const String payments = '/api/payments';
}
