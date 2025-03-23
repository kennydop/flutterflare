import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/core/constants/app_sizes.dart';
import 'package:flutterflare/core/extensions/extensions.dart';
import 'package:flutterflare/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

enum ToastType { success, error, warning, info, inAppNotification }

class Toast {
  // Keep track of the last toast message and timestamp to prevent duplicates
  static String? _lastToastMessage;
  static DateTime? _lastToastTime;

  static void showToast({
    required String message,
    String? title,
    ToastType type = ToastType.inAppNotification,
    Duration? duration,
    VoidCallback? onTap,
    VoidCallback? onClose,
  }) {
    final now = DateTime.now();
    if (_lastToastMessage == message &&
        _lastToastTime != null &&
        now.difference(_lastToastTime!).inMilliseconds < 500) {
      // Skip showing duplicate toast
      return;
    }

    _lastToastMessage = message;
    _lastToastTime = now;

    final toastType = _getToastificationType(type);
    toastification.show(
      type: toastType,
      style: ToastificationStyle.flatColored,
      title: Text(title ?? toastType.name.capitalizeFirst),
      description: Text(message),
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 4),
      borderRadius: AppSizes.r12,
      boxShadow: lowModeShadow,
      closeOnClick: false,
      primaryColor:
          toastType == ToastificationType.success
              ? AppColors.success
              : toastType == ToastificationType.error
              ? AppColors.error
              : toastType == ToastificationType.warning
              ? AppColors.warning
              : AppColors.primaryLight,
      foregroundColor: AppColors.textBody,
      showProgressBar: false,
    );
  }

  static void showNotification(
    RemoteMessage message, {
    BuildContext? context,
    WidgetRef? ref,
  }) {
    final containsRoute = message.data.containsKey('route');

    toastification.show(
      type: ToastificationType.info,
      style: ToastificationStyle.flatColored,
      primaryColor: AppColors.primaryLight,
      title: Text(message.notification?.title ?? 'Notification'),
      description: Text(message.notification?.body ?? ''),
      alignment: Alignment.topCenter,
      icon:
          message.notification?.android?.imageUrl != null
              ? Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: AppSizes.r10,
                  image: DecorationImage(
                    image: NetworkImage(
                      message.notification?.android?.imageUrl ?? '',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              )
              : null,
      autoCloseDuration: const Duration(seconds: 8),
      borderRadius: AppSizes.r12,
      boxShadow: lowModeShadow,
      closeOnClick: false,
      showProgressBar: false,
      // Handle tap on toast notification
      callbacks: ToastificationCallbacks(
        onTap:
            containsRoute
                ? (item) => _handleToastTap(message, context, ref)
                : null,
      ),
    );
  }

  // Handle taps on toast notifications
  static void _handleToastTap(
    RemoteMessage message,
    BuildContext? context,
    WidgetRef? ref,
  ) {
    if (message.data.isEmpty || !message.data.containsKey('route')) {
      return;
    }

    try {
      // First try using the provided context directly
      if (context != null) {
        _navigateWithContext(context, message.data);
        return;
      }

      // If we reach here and no context is available, log the issue
      print('Error: No context available for handling notification tap');
    } catch (e) {
      print('Error handling notification tap: $e');
    }
  }

  // Helper method to navigate using context
  static void _navigateWithContext(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    final route = data['route'] as String?;

    if (route == null) return;

    // Extract parameters
    final params = Map<String, dynamic>.from(data);
    params.remove('route');

    // Navigate based on route
    if (route.startsWith('/')) {
      context.push(route, extra: params.isNotEmpty ? params : null);
    } else {
      context.push('/$route', extra: params.isNotEmpty ? params : null);
    }
  }

  static void showSuccess(String message, {String? title}) {
    showToast(message: message, title: title, type: ToastType.success);
  }

  static void showError(String message, {String? title}) {
    showToast(message: message, title: title, type: ToastType.error);
  }

  static void showWarning(String message, {String? title}) {
    showToast(message: message, title: title, type: ToastType.warning);
  }

  static void showInfo(String message, {String? title}) {
    showToast(message: message, title: title, type: ToastType.info);
  }

  static ToastificationType _getToastificationType(ToastType type) {
    switch (type) {
      case ToastType.success:
        return ToastificationType.success;
      case ToastType.error:
        return ToastificationType.error;
      case ToastType.warning:
        return ToastificationType.warning;
      case ToastType.info:
        return ToastificationType.info;
      case ToastType.inAppNotification:
        return ToastificationType.info;
    }
  }
}
