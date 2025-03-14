import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/core/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_connectivity_service.g.dart';

// Connection status enum
enum NetworkStatus { online, offline }

// Network connectivity service to monitor internet connectivity
class NetworkConnectivityService {
  // Stream controller for network status updates
  final StreamController<NetworkStatus> _controller =
      StreamController<NetworkStatus>.broadcast();

  // Connectivity instance
  final Connectivity _connectivity;

  // Subscription to connection changes
  StreamSubscription? _subscription;

  // Current status
  NetworkStatus _currentStatus = NetworkStatus.online;

  // Get current network status
  NetworkStatus get status => _currentStatus;

  // Create a new network connectivity service
  NetworkConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity() {
    _init();
  }

  // Initialize the service
  void _init() {
    logger.d('NetworkConnectivity: Initializing connectivity monitoring');

    // Get initial status
    checkConnection().then((status) {
      _currentStatus = status;
      _controller.add(status);
    });

    // Listen for status changes
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      logger.d('NetworkConnectivity: Connection status changed to: $results');

      // If any connection is available, consider it online
      final hasConnection =
          results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.ethernet) ||
          results.contains(ConnectivityResult.vpn);

      final networkStatus =
          hasConnection ? NetworkStatus.online : NetworkStatus.offline;

      // Only notify if status changed
      if (_currentStatus != networkStatus) {
        _currentStatus = networkStatus;
        _controller.add(networkStatus);
      }
    });
  }

  // Stream of network status changes
  Stream<NetworkStatus> get onStatusChange => _controller.stream;

  // Check current connection (made public for direct access)
  Future<NetworkStatus> checkConnection() async {
    final results = await _connectivity.checkConnectivity();

    // If any connection is available, consider it online
    final hasConnection =
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.ethernet) ||
        results.contains(ConnectivityResult.vpn);

    return hasConnection ? NetworkStatus.online : NetworkStatus.offline;
  }

  // Check if currently connected
  Future<bool> isConnected() async {
    final results = await _connectivity.checkConnectivity();

    return results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.ethernet) ||
        results.contains(ConnectivityResult.vpn);
  }

  // Dispose resources
  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}

// Low-level provider for the network connectivity service
// This is used internally by NetworkConnectivityNotifier
@Riverpod(keepAlive: true)
NetworkConnectivityService networkConnectivityService(
  NetworkConnectivityServiceRef ref,
) {
  final service = NetworkConnectivityService();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
}

// State notifier that manages network status with AsyncValue for loading/error states
class NetworkConnectivityNotifier
    extends StateNotifier<AsyncValue<NetworkStatus>> {
  // The underlying connectivity service
  final NetworkConnectivityService _connectivity;

  // Subscription to status changes
  StreamSubscription? _subscription;

  // Creates a new network connectivity notifier
  NetworkConnectivityNotifier(this._connectivity)
    : super(const AsyncValue.loading()) {
    _init();
  }

  // Initialize the notifier
  void _init() async {
    try {
      // Set initial state
      final initialStatus = await _connectivity.checkConnection();
      if (mounted) {
        state = AsyncValue.data(initialStatus);
      }

      // Listen for changes
      _subscription = _connectivity.onStatusChange.listen(
        (status) {
          if (mounted) {
            state = AsyncValue.data(status);
            logger.d('NetworkConnectivityNotifier: Status changed to $status');
          }
        },
        onError: (error) {
          if (mounted) {
            state = AsyncValue.error(error, StackTrace.current);
            logger.e('NetworkConnectivityNotifier: Error: $error');
          }
        },
      );
    } catch (e, stack) {
      if (mounted) {
        state = AsyncValue.error(e, stack);
        logger.e('NetworkConnectivityNotifier: Init error: $e');
      }
    }
  }

  // Check if the device is currently connected
  Future<bool> isConnected() async {
    return await _connectivity.isConnected();
  }

  // Get the current status synchronously (may return null during loading)
  NetworkStatus? get currentStatus => state.value;

  // Get the connectivity status stream directly
  Stream<NetworkStatus> get statusStream => _connectivity.onStatusChange;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

// Primary provider for network connectivity - provides AsyncValue<NetworkStatus>
@Riverpod(keepAlive: true)
class Network extends _$Network {
  late NetworkConnectivityNotifier _notifier;

  @override
  AsyncValue<NetworkStatus> build() {
    final service = ref.watch(networkConnectivityServiceProvider);
    _notifier = NetworkConnectivityNotifier(service);

    ref.onDispose(() {
      _notifier.dispose();
    });

    return _notifier.state;
  }

  // Expose the notifier methods directly from the provider
  Future<bool> isConnected() async {
    return await _notifier.isConnected();
  }

  NetworkStatus? get currentStatus => _notifier.currentStatus;

  Stream<NetworkStatus> get statusStream => _notifier.statusStream;
}

// Helper provider to directly check if connected (without AsyncValue wrapper)
// Convenience provider for when you just need a yes/no answer
@riverpod
Future<bool> isConnected(IsConnectedRef ref) async {
  return await ref.watch(networkProvider.notifier).isConnected();
}
