import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/core/constants/app_strings.dart';
import 'package:flutterflare/core/services/loading/loading_service.dart';
import 'package:flutterflare/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:flutterflare/features/auth/views/login_view.dart';
import 'package:flutterflare/shared/widgets/or_divider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutterflare/core/constants/app_sizes.dart';
import 'package:flutterflare/shared/widgets/buttons/button.dart';
import 'package:flutterflare/shared/widgets/buttons/social_signin_button.dart';
import 'package:flutterflare/shared/widgets/inputs/email_input_field.dart';
import 'package:flutterflare/shared/widgets/inputs/password_input_field.dart';

class RegisterView extends ConsumerStatefulWidget {
  final String? previousRoutePath;
  const RegisterView({super.key, this.previousRoutePath = LoginView.routePath});

  static const String routePath = '/register';

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.pleaseConfirmPassword;
    }
    if (value != _passwordController.text) {
      return AppStrings.passwordsDoNotMatch;
    }
    return null;
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.withLoading(() async {
        await ref
            .read(authProvider.notifier)
            .createUserWithEmailAndPassword(
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
                    AppStrings.signUpPageHeader,
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  AppSizes.gapH8,
                  Text(
                    AppStrings.signUpPageSubHeader,
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
                    fieldId: 'register_email_input_field',
                    type: EmailInputFieldType.New,
                    textInputAction: TextInputAction.next,
                  ),
                  AppSizes.gapH16,
                  PasswordInputField(
                    label: AppStrings.passwordInputLabel,
                    hint: AppStrings.passwordInputHint,
                    controller: _passwordController,
                    fieldId: 'register_password_input_field',
                    type: PasswordInputFieldType.New,
                    textInputAction: TextInputAction.next,
                  ),
                  AppSizes.gapH16,
                  PasswordInputField(
                    label: AppStrings.confirmPasswordInputLabel,
                    hint: AppStrings.confirmPasswordInputHint,
                    controller: _confirmPasswordController,
                    fieldId: 'register_confirm_password_input_field',
                    type: PasswordInputFieldType.Existing,
                    textInputAction: TextInputAction.done,
                    validator: _validateConfirmPassword,
                  ),
                  AppSizes.gapH16,
                  Button(
                    label: AppStrings.signUp,
                    onPressed: _handleRegister,
                    isLoading: authState.isLoading,
                  ),
                  AppSizes.gapH16,
                  _buildSocialSignInSection(authState),
                  AppSizes.gapH16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(AppStrings.alreadyHaveAccount),
                      TextButton(
                        onPressed: () {
                          if (widget.previousRoutePath == LoginView.routePath) {
                            context.pop();
                          } else {
                            context.push(LoginView.routePath);
                          }
                        },
                        child: const Text(AppStrings.signIn),
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
