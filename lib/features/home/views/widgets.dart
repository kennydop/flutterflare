import 'package:flutter/material.dart';
import 'package:flutterflare/core/constants/app_sizes.dart';
import 'package:flutterflare/shared/widgets/buttons/button.dart';

class Widgets extends StatefulWidget {
  const Widgets({super.key});

  @override
  State<Widgets> createState() => _WidgetsState();
}

class _WidgetsState extends State<Widgets> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Primary button
          Button(
            label: 'Click Me',
            onPressed: () {},
          ),
          AppSizes.gapH16,

// Secondary button with loading state
          Button(
            label: 'Submit',
            variant: ButtonVariant.secondary,
            isLoading: true,
            onPressed: () {},
          ),
          AppSizes.gapH16,

// Outlined button with icons
          Button(
            label: 'Download',
            variant: ButtonVariant.outlined,
            leftIcon: Icons.download,
            onPressed: () {},
          ),
          AppSizes.gapH16,

          // Gradient button
          Button(
            label: 'Get Started',
            variant: ButtonVariant.gradient,
            size: ButtonSize.large,
            onPressed: () {},
          ),
          AppSizes.gapH16,

// Ghost button
          Button(
            label: 'Cancel',
            variant: ButtonVariant.ghost,
            onPressed: () {},
          ),
          AppSizes.gapH16,

// Link button
          Button(
            label: 'Learn More',
            variant: ButtonVariant.link,
            rightIcon: Icons.arrow_forward,
            onPressed: () {},
          ),
          AppSizes.gapH16,

// Custom styled button
          Button(
            label: 'Custom',
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(20),
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            onPressed: () {},
          ),
          AppSizes.gapH16,
        ],
      ),
    );
  }
}
