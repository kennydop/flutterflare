import 'package:flutter/material.dart';
import 'package:flutterflare/core/constants/app_sizes.dart';
import 'package:flutterflare/core/extensions/extensions.dart';
import 'package:flutterflare/core/theme/app_colors.dart';
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

  static void showNotification({
    required String message,
    String? title,
    Duration? duration,
    VoidCallback? onTap,
    VoidCallback? onClose,
    String? imageUrl,
  }) {
    toastification.show(
      type: ToastificationType.info,
      style: ToastificationStyle.flatColored,
      title: Text(title ?? 'Notification'),
      description: Text(message),
      alignment: Alignment.topCenter,
      icon: imageUrl != null ? Image.network(imageUrl) : null,
      autoCloseDuration: duration ?? const Duration(seconds: 8),
      borderRadius: AppSizes.r12,
      boxShadow: lowModeShadow,
      closeOnClick: false,
    );
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
