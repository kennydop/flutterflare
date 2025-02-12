// Shadows for the app
import 'package:flutter/material.dart';
import 'package:flutterflare/core/theme/app_colors.dart';

class AppShadows {
  static const color = AppColors.shadow;

  static const xs = BoxShadow(
    color: color,
    blurRadius: 10,
  );

  static const sm = BoxShadow(
    color: color,
    blurRadius: 20,
  );

  static const md = BoxShadow(
    color: color,
    blurRadius: 40,
  );

  static const lg = BoxShadow(
    color: color,
    blurRadius: 60,
    offset: Offset(0, 20),
  );
}
