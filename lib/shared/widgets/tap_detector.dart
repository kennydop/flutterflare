import 'package:flutter/material.dart';

class TapDetector extends StatelessWidget {
  final void Function()? onTap;
  final Widget child;
  const TapDetector({super.key, this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      onTap: onTap,
      child: child,
    );
  }
}
