import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterflare/core/configs/app_config.dart';
import 'package:flutterflare/core/logger/logger.dart';
import 'package:flutterflare/core/router/app_router.dart';
import 'package:flutterflare/core/services/storage/local_storage_service.dart';
import 'package:flutterflare/core/theme/app_theme.dart';
import 'package:flutterflare/shared/widgets/loading_overlay_widget.dart';
import 'package:toastification/toastification.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return LoadingOverlayWidget(
      child: ToastificationWrapper(
        child: MaterialApp.router(
          title: AppConfig.appName,
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
  WidgetsFlutterBinding.ensureInitialized();
  logger.d('Initializing app...');

  // Initialize Firebase
  await Firebase.initializeApp();
  logger.d('Firebase initialized...');

  // Initialize local storage service
  final localStorage = localStorageProvider.read(ProviderContainer());
  await localStorage.init();
  logger.d('Local storage initialized...');

  // Initialize Crashlytics
  if (!kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    logger.d('Crashlytics initialized...');
  }
}
