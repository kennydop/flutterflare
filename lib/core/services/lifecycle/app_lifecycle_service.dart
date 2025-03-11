import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/core/logger/logger.dart';
import 'package:flutterflare/features/auth/repositories/user_repository.dart';
import 'package:flutterflare/features/auth/viewmodels/auth_viewmodel.dart';

// Service that manages app lifecycle events
class AppLifecycleService extends WidgetsBindingObserver {
  final Ref _ref;
  bool _isInForeground = true;
  bool _isUpdatingStatus = false;

  AppLifecycleService(this._ref) {
    WidgetsBinding.instance.addObserver(this);
    _checkAndUpdateInitialStatus();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  // Check initial app state and update user status
  Future<void> _checkAndUpdateInitialStatus() async {
    // Small delay to ensure auth state is loaded
    await Future.delayed(const Duration(milliseconds: 500));
    _updateUserOnlineStatus(true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Update the user's online status based on the app lifecycle state
    if (state == AppLifecycleState.resumed) {
      _handleAppResumed();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _handleAppPaused();
    }
  }

  // Handle when the app is brought to the foreground
  void _handleAppResumed() {
    if (_isInForeground) return;
    _isInForeground = true;

    // Set online status to true when app is resumed
    _updateUserOnlineStatus(true);
    logger.d('App resumed - User online status updated');
  }

  // Handle when the app is sent to the background
  void _handleAppPaused() {
    if (!_isInForeground) return;
    _isInForeground = false;

    // Set online status to false when app is paused
    _updateUserOnlineStatus(false);
    logger.d('App paused - User online status updated');
  }

  // Update the current user's online status in Firestore
  Future<void> _updateUserOnlineStatus(bool isOnline) async {
    // Avoid concurrent updates
    if (_isUpdatingStatus) return;
    _isUpdatingStatus = true;

    try {
      final authState = _ref.read(authStateProvider);

      // Only proceed if auth state is not loading and user is logged in
      if (!authState.isLoading) {
        final user = authState.valueOrNull;

        if (user != null) {
          logger.d('Updating user ${user.uid} online status to: $isOnline');
          final userRepository = _ref.read(userRepositoryProvider);
          await userRepository.updateUser(user.uid, {
            'isOnline': isOnline,
            'lastLoginAt': DateTime.now().toIso8601String(),
          });
        } else {
          logger.d(
            'No authenticated user found - skipping online status update',
          );
        }
      } else {
        logger.d('Auth state is still loading - skipping online status update');
      }
    } catch (e) {
      logger.e('Error updating user online status: $e');
    } finally {
      _isUpdatingStatus = false;
    }
  }
}

// Provider for AppLifecycleService
final appLifecycleServiceProvider = Provider<AppLifecycleService>((ref) {
  final service = AppLifecycleService(ref);

  // Automatically dispose when no longer needed
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});
