enum Environment {
  dev,
  staging,
  prod,
}

class AppConfig {
  static Environment environment = Environment.dev;

  // API Configuration
  static String get apiUrl {
    switch (environment) {
      case Environment.dev:
        return 'http://localhost:5001/api';
      case Environment.staging:
        return 'https://staging-api.flutterflare.com';
      case Environment.prod:
        return 'https://api.flutterflare.com';
    }
  }

  // Feature Flags
  static bool get enableCrashlytics => environment != Environment.dev;
  static bool get enableAnalytics => environment != Environment.dev;

  // App Settings
  static const String appName = 'FlutterFlare';
  static const String appVersion = '1.0.0';

  // Cache Settings
  static const int cacheValidityDuration = 24 * 60 * 60; // 24 hours in seconds

  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
}
