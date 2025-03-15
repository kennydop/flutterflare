import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  // Primary Colors
  // light
  static const Color primaryLight50 = Color(0xFFECF0FE);
  static const Color primaryLight100 = Color(0xFFD8E2FD);
  static const Color primaryLight200 = Color(0xFFB6C9FB);
  static const Color primaryLight300 = Color(0xFF8FABFA);
  static const Color primaryLight400 = Color(0xFF688EF8);
  static const Color primaryLight500 = Color(0xFF4574F6);
  static const Color primaryLight600 = Color(0xFF0B48EE);
  static const Color primaryLight700 = Color(0xFF0936B4);
  static const Color primaryLight800 = Color(0xFF06257A);
  static const Color primaryLight900 = Color(0xFF03123A);
  static const Color primaryLight950 = Color(0xFF01091D);
  static const Color primaryLight = primaryLight500;
  // dark
  static const Color primaryDark50 = Color(0xFFE9EEFB);
  static const Color primaryDark100 = Color(0xFFD4DDF7);
  static const Color primaryDark200 = Color(0xFFADBEF0);
  static const Color primaryDark300 = Color(0xFF829BE8);
  static const Color primaryDark400 = Color(0xFF5779E0);
  static const Color primaryDark500 = Color(0xFF2E59D9);
  static const Color primaryDark600 = Color(0xFF2044B1);
  static const Color primaryDark700 = Color(0xFF183486);
  static const Color primaryDark800 = Color(0xFF10235B);
  static const Color primaryDark900 = Color(0xFF08112B);
  static const Color primaryDark950 = Color(0xFF040816);
  static const Color primaryDark = primaryDark500;

  // Secondary Colors
  // light
  static const Color secondaryLight50 = Color(0xFFF8F6F6);
  static const Color secondaryLight100 = Color(0xFFF2EEEE);
  static const Color secondaryLight200 = Color(0xFFE5DDDC);
  static const Color secondaryLight300 = Color(0xFFD8CCCB);
  static const Color secondaryLight400 = Color(0xFFCDBEBC);
  static const Color secondaryLight500 = Color(0xFFBFACAA);
  static const Color secondaryLight600 = Color(0xFFA18582);
  static const Color secondaryLight700 = Color(0xFF7A5F5C);
  static const Color secondaryLight800 = Color(0xFF513F3D);
  static const Color secondaryLight900 = Color(0xFF29201F);
  static const Color secondaryLight950 = Color(0xFF14100F);
  static const Color secondaryLight = secondaryLight500;
  // dark
  static const Color secondaryDark50 = Color(0xFFF8F6F6);
  static const Color secondaryDark100 = Color(0xFFF2EEEE);
  static const Color secondaryDark200 = Color(0xFFE5DDDC);
  static const Color secondaryDark300 = Color(0xFFD8CCCB);
  static const Color secondaryDark400 = Color(0xFFCDBEBC);
  static const Color secondaryDark500 = Color(0xFFBFACAA);
  static const Color secondaryDark600 = Color(0xFFA18582);
  static const Color secondaryDark700 = Color(0xFF7A5F5C);
  static const Color secondaryDark800 = Color(0xFF513F3D);
  static const Color secondaryDark900 = Color(0xFF29201F);
  static const Color secondaryDark950 = Color(0xFF14100F);
  static const Color secondaryDark = secondaryDark500;

  // Accent Colors
  static const Color accent = Color(0xFFE1E2EF);

  // Text Colors
  static const Color textHeading = Color(0xFF0F1938);
  static const Color textBody = Color(0xFF505963);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFF2E2C2F);
  static const Color placeholder = gray400;

  // Border Colors
  static const Color border = Color(0xFFE0E0E0);

  // Semantic Colors
  static const Color success = Color(0xFF3ED680);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = primaryLight;
  static const Color disabled = Color(0xFF999999);
  static const Color shadow = Color(0xFF454745);
  static const Color highlight = Color(0xFFF5F5F5);
  static const Color divider = gray200;

  // Gray Colors
  static const Color gray50 = Color(0xFFF8FAFC);
  static const Color gray100 = Color(0xFFF1F5F9);
  static const Color gray200 = Color(0xFFE2E8F0);
  static const Color gray300 = Color(0xFFCBD5E0);
  static const Color gray400 = Color(0xFF94A3B7);
  static const Color gray500 = Color(0xFF64748A);
  static const Color gray600 = Color(0xFF475568);
  static const Color gray700 = Color(0xFF334154);
  static const Color gray800 = Color(0xFF1E293A);
  static const Color gray900 = Color(0xFF111826);

  // Background Colors
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121212);

  // Surface Colors
  static const Color surfaceLight = backgroundLight;
  static const Color surfaceDark = backgroundDark;

  // Gradient Colors
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4574F6), Color(0xFFECF1FE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const Gradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFECF1FE), Color(0xFF4574F6)],
  );
  static Gradient bgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.purple.shade50, Colors.blue.shade100],
    stops: [0.0, 0.8],
  );
}
