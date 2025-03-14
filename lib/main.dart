import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/app/app.dart';
import 'package:flutterflare/core/configs/app_config.dart';
import 'package:flutterflare/core/theme/app_colors.dart';
import 'package:flutterflare/core/utils/device_utils.dart';

// Apply system UI style to make app more immersive
Future<void> redoSystemStyle([bool? darkMode]) async {
  darkMode ??= false;
  if (Platform.isAndroid) {
    // Get the Android SDK version
    final AndroidDeviceInfo androidInfo = await DeviceUtils.androidDeviceInfo();
    final bool edgeToEdge = androidInfo.version.sdkInt >= 29;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: darkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarColor:
            !edgeToEdge
                ? (darkMode ? AppColors.surfaceDark : AppColors.surfaceLight)
                : Colors.transparent,
        systemNavigationBarContrastEnforced: edgeToEdge,
        systemNavigationBarIconBrightness:
            darkMode ? Brightness.light : Brightness.dark,
        // systemStatusBarContrastEnforced: true,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
  } else {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  }
}

void main() async {
  // Initialize Flutter binding
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Preserve splash screen until auth is loaded
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Configure system UI style
  await redoSystemStyle();

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
