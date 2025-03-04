import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/core/services/loading/loading_service.dart';
import 'package:flutterflare/shared/widgets/loader.dart';

// A widget that shows a loading overlay when the loading state is true
class LoadingOverlayWidget extends ConsumerWidget {
  final Widget child;

  // Optional custom loading indicator widget
  final Widget? loadingIndicator;

  // Background color of the overlay
  final Color? backgroundColor;

  // If true, the overlay will be dismissible with a back button press
  final bool isDismissible;

  const LoadingOverlayWidget({
    super.key,
    required this.child,
    this.loadingIndicator,
    this.backgroundColor,
    this.isDismissible = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingOverlayProvider);

    return Stack(
      textDirection: TextDirection.ltr,
      children: [child, if (isLoading) _buildLoadingOverlay(context)],
    );
  }

  Widget _buildLoadingOverlay(BuildContext context) {
    return PopScope(
      canPop: isDismissible,
      child: Container(
        color: backgroundColor ?? Colors.black.withAlpha(128),
        child: Center(child: loadingIndicator ?? _defaultLoadingIndicator()),
      ),
    );
  }

  Widget _defaultLoadingIndicator() {
    return Container(
      height: 80,
      width: 80,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Loader(),
    );
  }
}
