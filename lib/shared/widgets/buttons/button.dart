import 'package:flutter/material.dart';
import 'package:flutterflare/core/constants/app_sizes.dart';
import 'package:flutterflare/core/theme/app_colors.dart';
import 'package:flutterflare/core/theme/app_text_styles.dart';
import 'package:flutterflare/shared/widgets/loader.dart';
import 'package:flutterflare/shared/widgets/tap_detector.dart';

enum ButtonVariant { primary, secondary, outlined, gradient, ghost, link }

enum ButtonSize { small, medium, large }

class Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final String? label;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const Button({
    super.key,
    required this.onPressed,
    this.child,
    this.label,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.leftIcon,
    this.rightIcon,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.borderRadius,
  }) : assert(
         child != null || label != null,
         'Either child or label must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get variant-specific styles
    final variantStyle = _getVariantStyle(colorScheme);
    final sizeStyle = _getSizeStyle(context);

    // Merge with custom styles
    final mergedStyle = variantStyle.copyWith(
      backgroundColor:
          backgroundColor != null
              ? WidgetStateProperty.all(backgroundColor)
              : null,
      foregroundColor:
          foregroundColor != null
              ? WidgetStateProperty.all(foregroundColor)
              : null,
      padding: padding != null ? WidgetStateProperty.all(padding) : null,
      minimumSize: WidgetStateProperty.all(
        Size(
          width ?? sizeStyle.width ?? double.infinity,
          height ?? sizeStyle.height ?? Theme.of(context).buttonTheme.height,
        ),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: borderRadius ?? AppSizes.r8Radius,
          side: variantStyle.side?.resolve({}) ?? BorderSide.none,
        ),
      ),
    );

    // Handle disabled state
    final isButtonDisabled = isDisabled || isLoading || onPressed == null;

    if (variant == ButtonVariant.gradient) {
      return _GradientButton(
        onPressed: isButtonDisabled ? null : onPressed,
        gradient: AppColors.primaryGradient,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: _ButtonContent(
          label: label,
          child: child,
          leftIcon: leftIcon,
          rightIcon: rightIcon,
          isLoading: isLoading,
          style: _getTextStyle(colorScheme),
          size: size,
        ),
      );
    }

    if (variant == ButtonVariant.link) {
      return _LinkButton(
        onPressed: isButtonDisabled ? null : onPressed,
        child: _ButtonContent(
          label: label,
          child: child,
          leftIcon: leftIcon,
          rightIcon: rightIcon,
          isLoading: isLoading,
          style: _getTextStyle(colorScheme),
          size: size,
        ),
      );
    }

    if (variant == ButtonVariant.ghost) {
      return TapDetector(
        onTap: isButtonDisabled ? null : onPressed,
        child: Padding(
          padding: padding ?? sizeStyle.padding,
          child: _ButtonContent(
            label: label,
            child: child,
            leftIcon: leftIcon,
            rightIcon: rightIcon,
            isLoading: isLoading,
            style: _getTextStyle(colorScheme),
            size: size,
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: isButtonDisabled ? null : onPressed,
      style: mergedStyle,
      child: _ButtonContent(
        label: label,
        child: child,
        leftIcon: leftIcon,
        rightIcon: rightIcon,
        isLoading: isLoading,
        style: _getTextStyle(colorScheme),
        size: size,
      ),
    );
  }

  ButtonStyle _getVariantStyle(ColorScheme colorScheme) {
    switch (variant) {
      case ButtonVariant.primary:
        return ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return colorScheme.primary.withOpacity(0.5);
            }
            return colorScheme.primary;
          }),
          foregroundColor: MaterialStateProperty.all(colorScheme.onPrimary),
        );

      case ButtonVariant.secondary:
        return ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return colorScheme.secondary.withOpacity(0.5);
            }
            return colorScheme.secondary;
          }),
          foregroundColor: MaterialStateProperty.all(colorScheme.onSecondary),
        );

      case ButtonVariant.outlined:
        return ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return colorScheme.primary.withOpacity(0.5);
            }
            return colorScheme.primary;
          }),
          side: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return BorderSide(color: colorScheme.primary.withOpacity(0.5));
            }
            return BorderSide(color: colorScheme.primary);
          }),
        );

      case ButtonVariant.gradient:
      case ButtonVariant.ghost:
      case ButtonVariant.link:
        return const ButtonStyle();
    }
  }

  _SizeStyle _getSizeStyle(BuildContext context) {
    switch (size) {
      case ButtonSize.small:
        return _SizeStyle(
          height: Theme.of(context).buttonTheme.height * 0.8,
          padding: AppSizes.marginH12,
          iconSize: AppSizes.iconSize16,
          spacing: AppSizes.g4,
        );
      case ButtonSize.medium:
        return _SizeStyle(
          height: Theme.of(context).buttonTheme.height,
          padding: AppSizes.marginH16,
          iconSize: AppSizes.iconSize20,
          spacing: AppSizes.g8,
        );
      case ButtonSize.large:
        return _SizeStyle(
          height: Theme.of(context).buttonTheme.height * 1.2,
          padding: AppSizes.marginH24,
          iconSize: AppSizes.iconSize24,
          spacing: AppSizes.g8,
        );
    }
  }

  TextStyle _getTextStyle(ColorScheme colorScheme) {
    final baseStyle = switch (variant) {
      ButtonVariant.primary => AppTextStyles.button.copyWith(
        color: colorScheme.onPrimary,
      ),
      ButtonVariant.secondary => AppTextStyles.button.copyWith(
        color: colorScheme.onSecondary,
      ),
      ButtonVariant.outlined => AppTextStyles.button.copyWith(
        color: colorScheme.primary,
      ),
      ButtonVariant.gradient => AppTextStyles.button.copyWith(
        color: colorScheme.onPrimary,
      ),
      ButtonVariant.ghost => AppTextStyles.button.copyWith(
        color: colorScheme.primary,
      ),
      ButtonVariant.link => AppTextStyles.button.copyWith(
        color: colorScheme.primary,
        decoration: TextDecoration.underline,
      ),
    };

    if (isDisabled) {
      return baseStyle.copyWith(color: baseStyle.color?.withAlpha(128));
    }

    return baseStyle;
  }
}

class _SizeStyle {
  final double? height;
  final double? width;
  final EdgeInsetsGeometry padding;
  final double iconSize;
  final double spacing;

  const _SizeStyle({
    this.height,
    this.width,
    required this.padding,
    required this.iconSize,
    required this.spacing,
  });
}

class _ButtonContent extends StatelessWidget {
  final String? label;
  final Widget? child;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final bool isLoading;
  final TextStyle? style;
  final ButtonSize size;

  const _ButtonContent({
    this.label,
    this.child,
    this.leftIcon,
    this.rightIcon,
    required this.isLoading,
    this.style,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: _getLoadingSize(),
        width: _getLoadingSize(),
        child: const Loader(size: LoaderSize.small),
      );
    }

    if (child != null) return child!;

    final sizeStyle = Button(
      onPressed: () {},
      label: '',
      size: size,
    )._getSizeStyle(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leftIcon != null) ...[
          Icon(leftIcon, size: sizeStyle.iconSize),
          SizedBox(width: sizeStyle.spacing),
        ],
        Text(label!, style: style),
        if (rightIcon != null) ...[
          SizedBox(width: sizeStyle.spacing),
          Icon(rightIcon, size: sizeStyle.iconSize),
        ],
      ],
    );
  }

  double _getLoadingSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }
}

class _GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Gradient gradient;
  final BorderRadius borderRadius;

  const _GradientButton({
    required this.onPressed,
    required this.child,
    required this.gradient,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: onPressed == null ? null : gradient,
        borderRadius: borderRadius,
        color: onPressed == null ? gradient.colors.first.withAlpha(128) : null,
      ),
      child: TapDetector(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: child,
        ),
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const _LinkButton({required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return TapDetector(onTap: onPressed, child: child);
  }
}
