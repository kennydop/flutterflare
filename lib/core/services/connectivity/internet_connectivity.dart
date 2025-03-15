import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutterflare/core/logger/logger.dart';

part 'internet_connectivity.g.dart';

// Internet connectivity state
class InternetConnectivityState {
  final InternetStatus status;
  final bool isFirstCheck;

  InternetConnectivityState({required this.status, required this.isFirstCheck});

  InternetConnectivityState copyWith({
    InternetStatus? status,
    bool? isFirstCheck,
  }) {
    return InternetConnectivityState(
      status: status ?? this.status,
      isFirstCheck: isFirstCheck ?? this.isFirstCheck,
    );
  }
}

// Internet connectivity notifier
@Riverpod(keepAlive: true)
class InternetConnectivity extends _$InternetConnectivity {
  late InternetConnection _internetConnection;
  late Stream<InternetStatus> _connectivityStream;
  @override
  InternetConnectivityState build() {
    _initialize();

    return InternetConnectivityState(
      status: InternetStatus.connected,
      isFirstCheck: true,
    );
  }

  Future<void> _initialize() async {
    _internetConnection = InternetConnection();
    _connectivityStream = _internetConnection.onStatusChange;

    // Check current status
    await _checkInitialConnectivity();

    // Listen for changes
    final subscription = _connectivityStream.listen(_statusListener);

    ref.onDispose(() {
      logger.d('InternetConnectivity: Disposing connectivity stream');
      subscription.cancel();
    });
  }

  // Check initial connectivity status
  Future<void> _checkInitialConnectivity() async {
    try {
      final initialStatus = await _internetConnection.internetStatus;
      state = state.copyWith(isFirstCheck: true, status: initialStatus);
    } catch (e) {
      logger.e('InternetConnectivity: Error checking initial status - $e');
    }
  }

  // Handle status change events from the connectivity stream
  void _statusListener(InternetStatus status) {
    final newState = state.copyWith(status: status, isFirstCheck: false);

    // Only update if state is different
    if (state.status != newState.status) {
      logger.d(
        'InternetConnectivity: Status changed to ${newState.status == InternetStatus.connected ? 'connected' : 'disconnected'}',
      );
      state = newState;
    }
  }

  // Check internet connectivity on demand
  Future<bool> checkConnectivity() async {
    try {
      final hasInternet = await _internetConnection.hasInternetAccess;

      // Update state if it's different from current check
      if (state.status !=
          (hasInternet
              ? InternetStatus.connected
              : InternetStatus.disconnected)) {
        logger.d(
          'InternetConnectivity: Manual check update to ${hasInternet ? 'connected' : 'disconnected'}',
        );
        state = state.copyWith(
          status:
              hasInternet
                  ? InternetStatus.connected
                  : InternetStatus.disconnected,
        );
      }

      return hasInternet;
    } catch (e) {
      logger.e('InternetConnectivity: Error in manual connectivity check - $e');
      return false;
    }
  }
}
