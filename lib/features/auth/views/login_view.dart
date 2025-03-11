import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/core/constants/app_sizes.dart';
import 'package:flutterflare/core/constants/app_strings.dart';
import 'package:flutterflare/core/services/loading/loading_service.dart';
import 'package:flutterflare/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:flutterflare/features/auth/views/forgot_password_view.dart';
import 'package:flutterflare/features/auth/views/register_view.dart';
import 'package:flutterflare/shared/widgets/buttons/button.dart';
import 'package:flutterflare/shared/widgets/buttons/social_signin_button.dart';
import 'package:flutterflare/shared/widgets/inputs/email_input_field.dart';
import 'package:flutterflare/shared/widgets/inputs/password_input_field.dart';
import 'package:flutterflare/shared/widgets/or_divider.dart';
import 'package:go_router/go_router.dart';

class LoginView extends ConsumerStatefulWidget {
  final String? previousRoutePath;
  const LoginView({super.key, this.previousRoutePath = RegisterView.routePath});

  static const String routePath = '/login';

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.withLoading(() async {
        await ref
            .read(authProvider.notifier)
            .signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            );
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    await ref.withLoading(() async {
      await ref.read(authProvider.notifier).signInWithGoogle();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Use the centralized auth error handler
    ref.watch(authErrorHandlerProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSizes.gutter,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppStrings.signInPageHeader,
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  AppSizes.gapH8,
                  Text(
                    AppStrings.signInPageSubHeader,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppSizes.gapH16,
                  EmailInputField(
                    label: AppStrings.emailInputLabel,
                    hint: AppStrings.emailInputHint,
                    controller: _emailController,
                    fieldId: 'sign_in_email_input_field',
                    type: EmailInputFieldType.Existing,
                    textInputAction: TextInputAction.next,
                  ),
                  AppSizes.gapH16,
                  PasswordInputField(
                    label: AppStrings.passwordInputLabel,
                    hint: AppStrings.passwordInputHint,
                    controller: _passwordController,
                    fieldId: 'sign_in_password_input_field',
                    type: PasswordInputFieldType.Existing,
                    textInputAction: TextInputAction.done,
                  ),
                  AppSizes.gapH8,
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed:
                          () => context.push(ForgotPasswordView.routePath),
                      child: const Text(AppStrings.forgotPassword),
                    ),
                  ),
                  AppSizes.gapH16,
                  Button(
                    label: AppStrings.signIn,
                    onPressed: _handleLogin,
                    isLoading: authState.isLoading,
                  ),
                  AppSizes.gapH16,
                  _buildSocialSignInSection(authState),
                  AppSizes.gapH16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(AppStrings.dontHaveAccount),
                      TextButton(
                        onPressed: () {
                          if (widget.previousRoutePath ==
                              RegisterView.routePath) {
                            context.pop();
                          } else {
                            context.push(RegisterView.routePath);
                          }
                        },
                        child: const Text(AppStrings.signUp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialSignInSection(AuthState authState) {
    return Column(
      children: [
        OrDivider(),
        AppSizes.gapH16,
        SocialSignInButton(
          provider: SocialSignInProvider.google,
          onPressed: _handleGoogleSignIn,
          isLoading: authState.isLoading,
        ),
      ],
    );
  }
}
