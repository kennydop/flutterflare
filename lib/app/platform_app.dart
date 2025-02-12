import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/core/configs/app_config.dart';
import 'package:flutterflare/core/router/app_router.dart';
import 'package:flutterflare/core/theme/app_theme.dart';

class PlatformApp extends ConsumerWidget {
  const PlatformApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    if (Platform.isIOS) {
      return CupertinoApp.router(
        title: AppConfig.appName,
        theme: CupertinoThemeData(
          brightness: MediaQuery.platformBrightnessOf(context),
          primaryColor: AppTheme.lightTheme.colorScheme.primary,
          scaffoldBackgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
          barBackgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
          textTheme: CupertinoTextThemeData(
            textStyle: AppTheme.lightTheme.textTheme.bodyMedium,
            navTitleTextStyle: AppTheme.lightTheme.textTheme.titleLarge,
            navLargeTitleTextStyle:
                AppTheme.lightTheme.textTheme.headlineMedium,
            actionTextStyle: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ),
        routerConfig: router,
      );
    }

    return MaterialApp.router(
      title: AppConfig.appName,
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
