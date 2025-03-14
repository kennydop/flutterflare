import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterflare/core/configs/app_config.dart';
import 'package:flutterflare/core/configs/env.dart';
import 'package:flutterflare/core/configs/flavor_banner.dart';
import 'package:flutterflare/core/logger/logger.dart';
import 'package:flutterflare/core/router/app_router.dart';
import 'package:flutterflare/core/services/lifecycle/app_lifecycle_service.dart';
import 'package:flutterflare/core/services/connectivity/network_connectivity_service.dart';
import 'package:flutterflare/core/services/storage/local_storage_service.dart';
import 'package:flutterflare/core/theme/app_theme.dart';
import 'package:flutterflare/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:flutterflare/firebase_options.dart';
import 'package:flutterflare/shared/widgets/app_error_widget.dart';
import 'package:flutterflare/shared/widgets/loading_overlay_widget.dart';
import 'package:toastification/toastification.dart';

bool removeSplash = false;

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize the app lifecycle service
    ref.watch(appLifecycleProvider);
    final auth = ref.watch(authProvider);

    final router = ref.watch(routerProvider);

    if (auth.isInitialized && !removeSplash) {
      removeSplash = true;
      FlutterNativeSplash.remove();
      logger.d('******* Splash removed *******');
    }

    return ToastificationWrapper(
      child: LoadingOverlayWidget(
        child: MaterialApp.router(
          title: AppConfig.appNameWithEnvironment,
          builder: (context, child) {
            ErrorWidget.builder = (errorDetails) {
              return const AppErrorWidget();
            };
            return FlavorBanner(child: child!);
          },
          theme: AppTheme.light,
          // darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          routerConfig: router,
        ),
      ),
    );
  }
}

Future<void> initializeApp() async {
  // Initialize Firebase
  await Firebase.initializeApp(
    name: AppConfig.environment.name,
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize local storage service
  final localStorage = localStorageProvider.read(ProviderContainer());
  await localStorage.init();

  // Initialize Crashlytics
  if (Env.enableCrashlytics) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    if (kDebugMode) {
      logger.d('Crashlytics initialized!');
    }
  }
}
