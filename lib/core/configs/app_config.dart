import 'package:flutter/material.dart';
import 'package:flutterflare/core/configs/env.dart';

enum Environment { dev, staging, prod }

class AppConfig {
  static Environment environment = Environment.dev;

  // App Settings
  static const String appName = 'FlutterFlare';
  static String get appNameWithEnvironment {
    // Get app name with environment for non-production builds
    if (environment == Environment.prod) {
      return appName;
    }
    return '$appName (${environment.name.toUpperCase()})';
  }

  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // Cache Settings
  static const int cacheValidityDuration = 24 * 60 * 60; // 24 hours in seconds

  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
}
