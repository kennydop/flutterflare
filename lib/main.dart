import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/app/app.dart';
import 'package:flutterflare/core/configs/app_config.dart';

void main() async {
  // Set environment
  AppConfig.environment = _getEnvironmentFromString(appFlavor);

  // Create the provider container
  final container = ProviderContainer();

  // Initialize the app
  await initializeApp();

  // Run the app with the initialized container
  runApp(UncontrolledProviderScope(container: container, child: const App()));
}

Environment _getEnvironmentFromString(String? env) {
  switch (env?.toLowerCase()) {
    case 'prod':
      return Environment.prod;
    case 'staging':
      return Environment.staging;
    case 'dev':
    default:
      return kDebugMode ? Environment.dev : Environment.prod;
  }
}
