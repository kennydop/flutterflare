// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_connectivity_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$networkConnectivityServiceHash() =>
    r'5c0bb55760b470e22c9a64b997d26f0c1b22edb1';

/// See also [networkConnectivityService].
@ProviderFor(networkConnectivityService)
final networkConnectivityServiceProvider =
    Provider<NetworkConnectivityService>.internal(
      networkConnectivityService,
      name: r'networkConnectivityServiceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$networkConnectivityServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NetworkConnectivityServiceRef = ProviderRef<NetworkConnectivityService>;
String _$isConnectedHash() => r'5a48c8231fa6f68830b6b9b4deba0f46bdc70179';

/// See also [isConnected].
@ProviderFor(isConnected)
final isConnectedProvider = AutoDisposeFutureProvider<bool>.internal(
  isConnected,
  name: r'isConnectedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isConnectedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsConnectedRef = AutoDisposeFutureProviderRef<bool>;
String _$networkHash() => r'c74b7d59fd394bb89871347e669c3d7b5a129c7f';

/// See also [Network].
@ProviderFor(Network)
final networkProvider =
    NotifierProvider<Network, AsyncValue<NetworkStatus>>.internal(
      Network.new,
      name: r'networkProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product') ? null : _$networkHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Network = Notifier<AsyncValue<NetworkStatus>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
