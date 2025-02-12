import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/core/constants/app_sizes.dart';
import 'package:flutterflare/core/constants/app_strings.dart';
import 'package:flutterflare/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:flutterflare/features/auth/views/register_view.dart';
import 'package:flutterflare/shared/widgets/buttons/button.dart';
import 'package:flutterflare/shared/widgets/inputs/email_input_field.dart';
import 'package:flutterflare/shared/widgets/inputs/password_input_field.dart';
import 'package:go_router/go_router.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  static const String routeName = '/login';

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
      await ref.read(authProvider.notifier).signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

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
                  if (authState.error != null) ...[
                    Text(
                      authState.error!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    AppSizes.gapH16,
                  ],
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
                      onPressed: () => context.push('/forgot-password'),
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                  AppSizes.gapH16,
                  Button(
                    label: AppStrings.signIn,
                    onPressed: _handleLogin,
                    isLoading: authState.isLoading,
                  ),
                  AppSizes.gapH16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        AppStrings.dontHaveAccount,
                      ),
                      TextButton(
                        onPressed: () => context.push(RegisterView.routeName),
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
}
