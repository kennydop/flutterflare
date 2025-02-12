import 'package:flutter/material.dart';

class AppTextStyles {
  static const String headingFontFamily = 'BricolageGrotesque';
  static const String bodyFontFamily = 'Urbanist';

  // Display Styles
  static const TextStyle display1 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 57,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.25,
    height: 1.12,
  );

  static const TextStyle display2 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 45,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.16,
  );

  // Headline Styles
  static const TextStyle headline1 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 36,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.22,
  );

  static const TextStyle headline2 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.25,
  );

  static const TextStyle headline3 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.29,
  );

  // Title Styles
  static const TextStyle title1 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
  );

  static const TextStyle title2 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
  );

  // Body Styles
  static const TextStyle body1 = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
    height: 1.5,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
    height: 1.43,
  );

  // Label Styles
  static const TextStyle label = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  // Button Text Styles
  static const TextStyle button = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
  );

  // Caption and Overline
  static const TextStyle caption = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
    height: 1.33,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: bodyFontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.6,
  );
}
