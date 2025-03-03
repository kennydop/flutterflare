import 'package:flutter/material.dart';
import 'package:flutterflare/core/constants/app_sizes.dart';
import 'package:flutterflare/shared/widgets/loader.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:colorful_iconify_flutter/icons/logos.dart';

enum SocialSignInProvider { google, apple, facebook, twitter }

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
    return MaterialButton(
      onPressed: isLoading ? null : onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: Colors.transparent,
      elevation: 0,
      hoverElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      disabledElevation: 0,
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
      provider == SocialSignInProvider.google
          ? Logos.google_icon
          : provider == SocialSignInProvider.apple
          ? Logos.apple
          : provider == SocialSignInProvider.facebook
          ? Logos.facebook
          : Logos.twitter,
    );
  }

  String _getButtonText() {
    switch (provider) {
      case SocialSignInProvider.google:
        return 'Continue with Google';
      case SocialSignInProvider.apple:
        return 'Continue with Apple';
      case SocialSignInProvider.facebook:
        return 'Continue with Facebook';
      case SocialSignInProvider.twitter:
        return 'Continue with X';
    }
  }
}
