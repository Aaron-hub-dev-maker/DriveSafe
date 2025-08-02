class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://api.example.com';

  // Auth endpoints
  static const String loginUrl = '$baseUrl/auth/login';
  static const String logoutUrl = '$baseUrl/auth/logout';
  static const String registerUrl = '$baseUrl/auth/register';
  static const String forgotPasswordUrl = '$baseUrl/auth/forgot-password';

  // User endpoints
  static const String userProfileUrl = '$baseUrl/user/profile';
  static const String updateProfileUrl = '$baseUrl/user/update';
}
