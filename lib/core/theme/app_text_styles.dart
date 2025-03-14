import 'package:flutter/material.dart';
import 'package:flutterflare/core/constants/app_sizes.dart';
import 'package:flutterflare/core/theme/app_colors.dart';

class AppTextStyles {
  static const String headingFontFamily = 'DelaGothicOne';
  static const String bodyFontFamily = 'Urbanist';

  // Display Styles
  static const TextStyle display1 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: AppSizes.s64,
    // fontWeight: FontWeight.bold,
    letterSpacing: -0.25,
    height: 1.12,
    color: AppColors.textHeading,
  );

  static const TextStyle display2 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: AppSizes.s48,
    // fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.16,
    color: AppColors.textHeading,
  );

  // Headline Styles
  static const TextStyle headline1 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: AppSizes.s36,
    // fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.22,
    color: AppColors.textHeading,
  );

  static const TextStyle headline2 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: AppSizes.s32,
    // fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.25,
    color: AppColors.textHeading,
  );

  static const TextStyle headline3 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: AppSizes.s24,
    // fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.29,
    color: AppColors.textHeading,
  );

  // Title Styles
  static const TextStyle title1 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: AppSizes.s24,
    // fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
    color: AppColors.textHeading,
  );

  static const TextStyle title2 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: AppSizes.s20,
    // fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    color: AppColors.textHeading,
  );

  // Body Styles
  static const TextStyle body1 = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: AppSizes.s16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
    height: 1.5,
    color: AppColors.textBody,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: AppSizes.s14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
    height: 1.43,
    color: AppColors.textBody,
  );

  // Label Styles
  static const TextStyle label = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: AppSizes.s14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColors.textBody,
  );

  // Button Text Styles
  static const TextStyle button = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: AppSizes.s14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
  );

  // Caption and Overline
  static const TextStyle caption = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: AppSizes.s12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColors.textBody,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: AppSizes.s10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.6,
    color: AppColors.textBody,
  );
}
