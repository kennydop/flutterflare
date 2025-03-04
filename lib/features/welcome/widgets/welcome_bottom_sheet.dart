import 'package:flutter/material.dart';
import 'package:flutterflare/core/constants/app_sizes.dart';
import 'package:flutterflare/core/constants/app_strings.dart';
import 'package:flutterflare/core/theme/app_colors.dart';
import 'package:flutterflare/features/auth/views/login_view.dart';
import 'package:flutterflare/features/auth/views/register_view.dart';
import 'package:flutterflare/shared/widgets/tap_detector.dart';
import 'package:go_router/go_router.dart';

class WelcomeBottomSheet extends StatelessWidget {
  const WelcomeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: AppSizes.r24Radius,
      ),
      padding: AppSizes.paddingAll16,
      margin: EdgeInsets.only(
        left: AppSizes.gutterValue,
        right: AppSizes.gutterValue,
        bottom:
            MediaQuery.of(context).padding.bottom +
            10 +
            MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Wrap(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.getStarted,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TapDetector(
                child: Container(
                  padding: AppSizes.paddingAll6,
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: AppSizes.s20),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),

          const Text(
            'Register for events, subscribe to calendars and manage events you\'re going to.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),

          // Login with phone button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.push(LoginView.routePath);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Continue with Phone',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Login with email button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                context.push(RegisterView.routePath);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Continue with Email',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Social auth
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Icon(Icons.apple, color: Colors.black),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Icon(
                    Icons.g_mobiledata,
                    color: Colors.blue,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
