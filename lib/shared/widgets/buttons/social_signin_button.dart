import 'package:flutter/material.dart';
import 'package:flutterflare/core/constants/app_sizes.dart';
import 'package:flutterflare/shared/widgets/buttons/button.dart';
import 'package:flutterflare/shared/widgets/loader.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:colorful_iconify_flutter/icons/logos.dart';

enum SocialSignInProvider { google, apple }

class SocialSignInButton extends StatelessWidget {
  final SocialSignInProvider provider;
  final VoidCallback onPressed;
  final bool isLoading;

  const SocialSignInButton({
    super.key,
    required this.provider,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: isLoading ? null : onPressed,
      variant: ButtonVariant.ghost,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            Loader(size: LoaderSize.small)
          else
            _buildProviderIcon(),
          if (!isLoading) ...[
            AppSizes.gapW8,
            Text(
              _getButtonText(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProviderIcon() {
    return Iconify(
      provider == SocialSignInProvider.google ? Logos.google_icon : Logos.apple,
    );
  }

  String _getButtonText() {
    switch (provider) {
      case SocialSignInProvider.google:
        return 'Continue with Google';
      case SocialSignInProvider.apple:
        return 'Continue with Apple';
    }
  }
}
