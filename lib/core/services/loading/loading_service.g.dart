// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loading_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loadingOverlayGlobalHash() =>
    r'9107379bfc1f5ee1f88ae9b985596cc4dee3974a';

/// See also [loadingOverlayGlobal].
@ProviderFor(loadingOverlayGlobal)
final loadingOverlayGlobalProvider = Provider<bool>.internal(
  loadingOverlayGlobal,
  name: r'loadingOverlayGlobalProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$loadingOverlayGlobalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LoadingOverlayGlobalRef = ProviderRef<bool>;
String _$loadingOverlayHash() => r'3a8737b7a3048aca498455f2a7cf335b46b23388';

/// See also [LoadingOverlay].
@ProviderFor(LoadingOverlay)
final loadingOverlayProvider =
    AutoDisposeNotifierProvider<LoadingOverlay, bool>.internal(
      LoadingOverlay.new,
      name: r'loadingOverlayProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$loadingOverlayHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LoadingOverlay = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
