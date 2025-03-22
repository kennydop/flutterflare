import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutterflare/core/logger/logger.dart';
import 'package:flutterflare/core/services/lifecycle/app_lifecycle_service.dart';

part 'internet_connectivity.g.dart';

// Internet connectivity state
class InternetConnectivityState {
  final InternetStatus status;
  final bool isFirstCheck;
  final bool shouldShowAlert;

  InternetConnectivityState({
    required this.status,
    required this.isFirstCheck,
    this.shouldShowAlert = true,
  });

  InternetConnectivityState copyWith({
    InternetStatus? status,
    bool? isFirstCheck,
    bool? shouldShowAlert,
  }) {
    return InternetConnectivityState(
      status: status ?? this.status,
      isFirstCheck: isFirstCheck ?? this.isFirstCheck,
      shouldShowAlert: shouldShowAlert ?? this.shouldShowAlert,
    );
  }
}

// Internet connectivity notifier
@Riverpod(keepAlive: true)
class InternetConnectivity extends _$InternetConnectivity {
  late InternetConnection _internetConnection;
  late Stream<InternetStatus> _connectivityStream;
  bool _isAppInForeground = true;

  @override
  InternetConnectivityState build() {
    _initialize();

    return InternetConnectivityState(
      status: InternetStatus.connected,
      isFirstCheck: true,
      shouldShowAlert: false,
    );
  }

  Future<void> _initialize() async {
    _internetConnection = InternetConnection();
    _connectivityStream = _internetConnection.onStatusChange;

    // // Watch app lifecycle to track foreground/background state
    // final lifecycleService = ref.watch(appLifecycleProvider);

    // Update the foreground tracking variable when app lifecycle changes
    ref.listen(appLifecycleProvider, (_, service) {
      _isAppInForeground = service.isInForeground;

      // If app comes back to foreground, force connectivity check
      // if (_isAppInForeground) {
      //   logger.d('InternetConnectivity: Forcing a connectivity check');
      //   forceConnectivityCheck();
      // }
    });

    // Check current status
    await _checkInitialConnectivity();

    // Listen for changes
    final subscription = _connectivityStream.listen(_statusListener);

    ref.onDispose(() {
      subscription.cancel();
    });
  }

  // Check initial connectivity status
  Future<void> _checkInitialConnectivity() async {
    try {
      final initialStatus = await _internetConnection.internetStatus;
      state = state.copyWith(
        isFirstCheck: true,
        status: initialStatus,
        shouldShowAlert: _isAppInForeground,
      );
    } catch (e) {
      logger.e('InternetConnectivity: Error checking initial status - $e');
    }
  }

  // Handle status change events from the connectivity stream
  void _statusListener(InternetStatus status) {
    // Ignore status changes if app is in background
    if (!_isAppInForeground) {
      logger.d(
        'InternetConnectivity: Ignoring status change while app is in background',
      );
      return;
    }

    final newState = state.copyWith(
      status: status,
      isFirstCheck: false,
      shouldShowAlert: true,
    );

    // Only update if state is different
    if (state.status != newState.status) {
      logger.d(
        'InternetConnectivity: Status changed to ${newState.status == InternetStatus.connected ? "connected" : "disconnected"}',
      );
      state = newState;
    }
  }

  // Check internet connectivity on demand
  Future<bool> checkConnectivity() async {
    try {
      final hasInternet = await _internetConnection.hasInternetAccess;
      final newStatus =
          hasInternet ? InternetStatus.connected : InternetStatus.disconnected;

      // Update state if it's different from current check
      if (state.status != newStatus) {
        logger.d(
          'InternetConnectivity: Manual check update to ${hasInternet ? "connected" : "disconnected"}',
        );

        state = state.copyWith(
          status: newStatus,
          shouldShowAlert: _isAppInForeground,
        );
      }

      return hasInternet;
    } catch (e) {
      logger.e('InternetConnectivity: Error in manual connectivity check - $e');
      return false;
    }
  }

  // // Force a connectivity check when app is resumed
  // Future<void> forceConnectivityCheck() async {
  //   logger.d('InternetConnectivity: Forcing connectivity check');

  //   try {
  //     final hasInternet = await _internetConnection.hasInternetAccess;
  //     final newStatus =
  //         hasInternet ? InternetStatus.connected : InternetStatus.disconnected;

  //     // Only show alert if there's a change in connectivity
  //     final shouldShowAlert = state.status != newStatus && _isAppInForeground;

  //     state = state.copyWith(
  //       status: newStatus,
  //       isFirstCheck: false,
  //       shouldShowAlert: shouldShowAlert,
  //     );

  //     if (shouldShowAlert) {
  //       logger.d(
  //         'InternetConnectivity: Status changed on force check to ${hasInternet ? "connected" : "disconnected"}',
  //       );
  //     } else {
  //       logger.d(
  //         'InternetConnectivity: Status unchanged on force check: ${hasInternet ? "connected" : "disconnected"}',
  //       );
  //     }
  //   } catch (e) {
  //     logger.e('InternetConnectivity: Error in force connectivity check - $e');
  //   }
  // }
}
