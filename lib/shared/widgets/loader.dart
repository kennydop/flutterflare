import 'package:flutter/material.dart';
import 'package:flutterflare/core/theme/app_colors.dart';

enum LoaderSize { small, medium, large }

class Loader extends StatelessWidget {
  final Color? color;
  final double? strokeWidth;
  final LoaderSize size;
  const Loader({
    super.key,
    this.color,
    this.strokeWidth,
    this.size = LoaderSize.medium,
  });

  double _getStrokeWidth() {
    switch (size) {
      case LoaderSize.small:
        return 2;
      case LoaderSize.medium:
        return 4;
      case LoaderSize.large:
        return 6;
    }
  }

  double _getSize() {
    switch (size) {
      case LoaderSize.small:
        return 24;
      case LoaderSize.medium:
        return 32;
      case LoaderSize.large:
        return 40;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: _getSize(),
        width: _getSize(),
        child: CircularProgressIndicator.adaptive(
          strokeCap: StrokeCap.round,
          strokeWidth: strokeWidth ?? _getStrokeWidth(),
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppColors.primaryLight,
          ),
        ),
      ),
    );
  }
}
