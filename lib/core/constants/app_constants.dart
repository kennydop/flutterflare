class AppConstants {
  // Storage Keys
  static const String themeKey = 'app_theme';
  static const String preferencesBoxName = 'preferences';
  static const String onboardingCompletedKey = 'onboarding_completed';

  // Error Messages
  static const String networkError = 'Please check your internet connection';
  static const String serverError =
      'Something went wrong. Please try again later';

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

  // Social Media URLs
  static const String privacyPolicyUrl = 'https://flutterflare.dev/privacy';
  static const String termsOfServiceUrl = 'https://flutterflare.dev/tos';
  static const String supportUrl = 'https://flutterflare.dev/support';
}
