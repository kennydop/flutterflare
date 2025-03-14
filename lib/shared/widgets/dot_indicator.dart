import 'package:flutter/material.dart';
import 'package:flutterflare/core/constants/app_sizes.dart';

class DotIndicator extends StatelessWidget {
  final int dotsCount;
  final int activeIndex;
  final double dotSize;
  final double spacing;
  final Color? activeColor;
  final Color? inactiveColor;
  final double activeDotSize;

  const DotIndicator({
    Key? key,
    required this.dotsCount,
    required this.activeIndex,
    this.dotSize = AppSizes.s8,
    this.spacing = AppSizes.s6,
    this.activeColor,
    this.inactiveColor,
    this.activeDotSize = AppSizes.s8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(dotsCount, (index) {
        final isActive = index == activeIndex;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          height: isActive ? activeDotSize : dotSize,
          width: isActive ? activeDotSize : dotSize,
          decoration: BoxDecoration(
            color:
                isActive
                    ? (activeColor ?? Theme.of(context).colorScheme.primary)
                    : (inactiveColor ??
                        Theme.of(context).colorScheme.primary.withAlpha(100)),
            borderRadius: AppSizes.rFull,
          ),
        );
      }),
    );
  }
}
