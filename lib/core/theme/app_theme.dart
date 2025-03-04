import 'package:flutter/material.dart';
import 'package:flutterflare/core/constants/app_sizes.dart';
import 'package:flutterflare/core/theme/app_colors.dart';
import 'package:flutterflare/core/theme/app_text_styles.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryLight,
        onPrimary: AppColors.textOnPrimary,
        secondary: AppColors.secondaryLight,
        onSecondary: AppColors.textOnSecondary,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textBody,
        error: AppColors.error,
        onError: Colors.white,
      ),
      fontFamily: AppTextStyles.bodyFontFamily,
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.display1,
        displayMedium: AppTextStyles.display2,
        headlineLarge: AppTextStyles.headline1,
        headlineMedium: AppTextStyles.headline2,
        headlineSmall: AppTextStyles.headline3,
        titleLarge: AppTextStyles.title1,
        titleMedium: AppTextStyles.title2,
        bodyLarge: AppTextStyles.body1,
        bodyMedium: AppTextStyles.body2,
        labelLarge: AppTextStyles.label,
        labelMedium: AppTextStyles.button,
        bodySmall: AppTextStyles.caption,
        labelSmall: AppTextStyles.overline,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textHeading,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: .15,
        titleTextStyle: AppTextStyles.body1,
      ),
      dividerTheme: const DividerThemeData(color: AppColors.divider),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.m16,
          vertical: AppSizes.m8,
        ),
      ),
      cardTheme: const CardTheme(
        color: AppColors.surfaceLight,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: AppSizes.r16Radius),
      ),
      iconTheme: const IconThemeData(color: AppColors.gray500),
      buttonTheme: const ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: AppSizes.r8Radius),
        buttonColor: AppColors.primaryLight,
        textTheme: ButtonTextTheme.primary,
        height: AppSizes.s48,
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusColor: AppColors.primaryLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.m16,
          vertical: AppSizes.m8,
        ),
        iconColor: AppColors.textHeading,
        border: const OutlineInputBorder(borderRadius: AppSizes.r8Radius),
        filled: true,
        fillColor: AppColors.gray100,
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppSizes.r8Radius,
          borderSide: BorderSide(color: AppColors.gray300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppSizes.r8Radius,
          borderSide: BorderSide(color: AppColors.primaryLight),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppSizes.r8Radius,
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppSizes.r8Radius,
          borderSide: BorderSide(color: AppColors.error),
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: AppSizes.r8Radius,
          borderSide: BorderSide(color: AppColors.gray100),
        ),
        hintStyle: AppTextStyles.body2.copyWith(color: AppColors.placeholder),
        labelStyle: AppTextStyles.body2.copyWith(color: AppColors.textBody),
        prefixIconColor: AppColors.gray500,
        suffixIconColor: AppColors.gray500,
      ),
      chipTheme: ChipThemeData(
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppSizes.r8Radius),
        selectedColor: AppColors.primaryLight,
        checkmarkColor: AppColors.textOnPrimary,
        labelStyle: AppTextStyles.body2.copyWith(
          color: const ChipLabelColor(),
          fontSize: AppSizes.fontSize14,
          fontWeight: FontWeight.w500,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryLight,
      ),
      indicatorColor: AppColors.primaryLight,
    );
  }

  // static ThemeData get dark {
  //   return ThemeData(
  //     useMaterial3: true,
  //     brightness: Brightness.dark,
  //     colorScheme: const ColorScheme.dark(
  //       primary: AppColors.primaryDark,
  //       onPrimary: AppColors.textOnPrimary,
  //       secondary: AppColors.secondaryDark,
  //       onSecondary: AppColors.textOnSecondary,
  //       surface: AppColors.surfaceDark,
  //       onSurface: AppColors.textBody,
  //       error: AppColors.error,
  //       onError: Colors.white,
  //     ),
  //     fontFamily: AppTextStyles.bodyFontFamily,
  //     textTheme: const TextTheme(
  //       displayLarge: AppTextStyles.display1,
  //       displayMedium: AppTextStyles.display2,
  //       headlineLarge: AppTextStyles.headline1,
  //       headlineMedium: AppTextStyles.headline2,
  //       headlineSmall: AppTextStyles.headline3,
  //       titleLarge: AppTextStyles.title1,
  //       titleMedium: AppTextStyles.title2,
  //       bodyLarge: AppTextStyles.body1,
  //       bodyMedium: AppTextStyles.body2,
  //       labelLarge: AppTextStyles.label,
  //       labelMedium: AppTextStyles.button,
  //       bodySmall: AppTextStyles.caption,
  //       labelSmall: AppTextStyles.overline,
  //     ),
  //     appBarTheme: const AppBarTheme(
  //       backgroundColor: AppColors.surfaceDark,
  //       foregroundColor: AppColors.textOnPrimary,
  //       elevation: 0,
  //     ),
  //     scaffoldBackgroundColor: AppColors.backgroundDark,
  //     cardTheme: CardTheme(
  //       color: AppColors.surfaceDark,
  //       elevation: 2,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //     ),
  //     buttonTheme: ButtonThemeData(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       buttonColor: AppColors.primaryDark,
  //       textTheme: ButtonTextTheme.primary,
  //     ),
  //   );
  // }
}

class ChipLabelColor extends Color implements WidgetStateColor {
  const ChipLabelColor() : super(_default);

  static const int _default = 0xFF000000;

  @override
  Color resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return AppColors.textOnPrimary;
    }
    return AppColors.textBody;
  }
}
