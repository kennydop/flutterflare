import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/core/constants/app_sizes.dart';
import 'package:flutterflare/core/constants/app_strings.dart';
import 'package:flutterflare/core/services/loading/loading_service.dart';
import 'package:flutterflare/core/theme/app_colors.dart';
import 'package:flutterflare/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:flutterflare/features/auth/views/login_view.dart';
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
          AppStrings.forgotPassword,
          style: Theme.of(context).textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        AppSizes.gapH8,
        Text(
          AppStrings.forgotPasswordDescription,
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
          label: AppStrings.resetPassword,
          onPressed: _handleResetPassword,
          isLoading: authState.isLoading,
        ),
        AppSizes.gapH16,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(AppStrings.rememberYourPassword),
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
        const Icon(
          Icons.mark_email_read,
          size: AppSizes.s80,
          color: AppColors.success,
        ),
        AppSizes.gapH16,
        Text(
          AppStrings.checkYourInbox,
          style: Theme.of(context).textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        AppSizes.gapH8,
        Text(
          '${AppStrings.weSentAResetPasswordLinkTo}:\n${_emailController.text}',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        AppSizes.gapH16,
        Button(
          label: AppStrings.signIn,
          onPressed: () => context.go(LoginView.routePath),
        ),
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
