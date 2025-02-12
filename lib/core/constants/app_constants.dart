class AppConstants {
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';

  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String profileEndpoint = '/user/profile';

  // Error Messages
  static const String networkError = 'Please check your internet connection';
  static const String serverError =
      'Something went wrong. Please try again later';
  static const String authError = 'Invalid email or password';

  // Validation
  static const int minPasswordLength = 8;
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  // Animation Durations
  static const int shortAnimationDuration = 200; // milliseconds
  static const int mediumAnimationDuration = 350; // milliseconds
  static const int longAnimationDuration = 500; // milliseconds

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;

  // Cache Duration
  static const int defaultCacheDuration = 24 * 60 * 60; // 24 hours in seconds

  // Assets
  static const String logoPath = 'assets/images/logo.png';
  static const String placeholderImagePath = 'assets/images/placeholder.png';

  // Social Media URLs
  static const String privacyPolicyUrl = 'https://flutterflare.dev/privacy';
  static const String termsOfServiceUrl = 'https://flutterflare.dev/terms';
  static const String supportUrl = 'https://flutterflare.dev/support';
}
