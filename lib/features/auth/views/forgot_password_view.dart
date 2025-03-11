import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/core/constants/app_sizes.dart';
import 'package:flutterflare/core/constants/app_strings.dart';
import 'package:flutterflare/core/services/loading/loading_service.dart';
import 'package:flutterflare/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:flutterflare/shared/widgets/buttons/button.dart';
import 'package:flutterflare/shared/widgets/inputs/email_input_field.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordView extends ConsumerStatefulWidget {
  const ForgotPasswordView({super.key});

  static const String routePath = '/forgot-password';

  @override
  ConsumerState<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _resetEmailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.withLoading(() async {
        await ref
            .read(authProvider.notifier)
            .sendPasswordResetEmail(_emailController.text.trim());
      });

      setState(() {
        _resetEmailSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Use the centralized error handler
    ref.watch(authErrorHandlerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSizes.gutter,
            child: Form(
              key: _formKey,
              child:
                  _resetEmailSent
                      ? _buildSuccessMessage(context)
                      : _buildResetForm(context, authState),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetForm(BuildContext context, AuthState authState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Forgot Password?',
          style: Theme.of(context).textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        AppSizes.gapH8,
        Text(
          'Enter your email address and we\'ll send you a link to reset your password',
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
          fieldId: 'forgot_password_email_input_field',
          type: EmailInputFieldType.Existing,
          textInputAction: TextInputAction.done,
        ),
        AppSizes.gapH16,
        Button(
          label: 'Reset Password',
          onPressed: _handleResetPassword,
          isLoading: authState.isLoading,
        ),
        AppSizes.gapH16,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Remember your password?'),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text(AppStrings.signIn),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuccessMessage(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.mark_email_read, size: 70, color: Colors.green),
        AppSizes.gapH16,
        Text(
          'Check your inbox',
          style: Theme.of(context).textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        AppSizes.gapH8,
        Text(
          'We sent a password reset link to:\n${_emailController.text}',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        AppSizes.gapH16,
        Button(label: AppStrings.signIn, onPressed: () => context.go('/login')),
        AppSizes.gapH8,
        TextButton(
          onPressed: () {
            setState(() {
              _resetEmailSent = false;
              _emailController.clear();
            });
          },
          child: const Text('Try a different email'),
        ),
      ],
    );
  }
}
