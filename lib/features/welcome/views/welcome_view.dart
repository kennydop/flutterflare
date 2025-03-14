import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterflare/core/constants/app_images.dart';
import 'package:flutterflare/core/constants/app_sizes.dart';
import 'package:flutterflare/core/constants/app_strings.dart';
import 'package:flutterflare/features/auth/views/login_view.dart';
import 'package:flutterflare/features/auth/views/register_view.dart';
import 'package:flutterflare/shared/widgets/buttons/button.dart';
import 'package:go_router/go_router.dart';

class WelcomeView extends StatefulWidget {
  static const String routePath = '/welcome';

  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.purple.shade50, Colors.blue.shade100],
              ),
            ),
            child: Center(
              child: Image.asset(
                AppImages.logo,
                width: AppSizes.s120,
                height: AppSizes.s120,
              ),
            ),
          ),

          // Main content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Bottom text and button
              Text(
                AppStrings.appShortDescription.replaceAll(', ', ',\n'),
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              AppSizes.gapH16,
              Padding(
                padding: AppSizes.gutter,
                child: Button(
                  onPressed:
                      () => context.push(
                        RegisterView.routePath,
                        extra: WelcomeView.routePath,
                      ),
                  child: const Text(AppStrings.getStarted),
                ),
              ),
              AppSizes.gapH16,
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: AppStrings.alreadyHaveAccount,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextSpan(
                      text: AppStrings.signIn,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap =
                                () => context.push(
                                  LoginView.routePath,
                                  extra: WelcomeView.routePath,
                                ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height:
                    MediaQuery.of(context).padding.bottom > 0
                        ? MediaQuery.of(context).padding.bottom
                        : AppSizes.s16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
