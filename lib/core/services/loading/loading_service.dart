import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loading_service.g.dart';

// A service that manages the global loading state.
// Use this to show a loading overlay on top of the entire app.
@riverpod
class LoadingOverlay extends _$LoadingOverlay {
  @override
  bool build() => false;

  // Show the loading overlay
  void show() {
    state = true;
  }

  // Hide the loading overlay
  void hide() {
    state = false;
  }

  // Execute an async function while showing the loading overlay
  // The overlay will be automatically hidden when the future completes
  Future<T> during<T>(Future<T> Function() future) async {
    try {
      show();
      return await future();
    } finally {
      hide();
    }
  }
}

// A global provider that offers access to the loading overlay service
final loadingOverlayGlobalProvider = StateProvider<bool>((ref) {
  // We link to the autoDispose provider so it synchronizes
  return ref.watch(loadingOverlayProvider);
});

// Extension on WidgetRef to make it easier to use the loading overlay
extension LoadingOverlayRefExtension on WidgetRef {
  void showLoading() {
    read(loadingOverlayProvider.notifier).show();
  }

  void hideLoading() {
    read(loadingOverlayProvider.notifier).hide();
  }

  Future<T> withLoading<T>(Future<T> Function() future) async {
    return read(loadingOverlayProvider.notifier).during(future);
  }
}
