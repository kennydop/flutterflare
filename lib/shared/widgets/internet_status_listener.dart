import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/core/constants/app_sizes.dart';
import 'package:flutterflare/core/services/connectivity/internet_connectivity.dart';
import 'package:flutterflare/core/theme/app_colors.dart';
import 'package:flutterflare/core/constants/app_strings.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetStatusListener extends ConsumerWidget {
  final Widget child;

  const InternetStatusListener({Key? key, required this.child})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the network provider
    ref.listen<InternetConnectivityState>(internetConnectivityProvider, (
      previous,
      current,
    ) {
      // Only show snackbar if the shouldShowAlert flag is true
      if (current.shouldShowAlert &&
          ((current.isFirstCheck &&
                  current.status == InternetStatus.disconnected) ||
              (!current.isFirstCheck && previous != current))) {
        _showNetworkStatusSnackBar(
          context,
          current.status == InternetStatus.connected,
        );
      }
    });

    return child;
  }

  void _showNetworkStatusSnackBar(BuildContext context, bool status) {
    // Remove any existing snackbars
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(status ? Icons.wifi : Icons.wifi_off, color: AppColors.white),
          AppSizes.gapW12,
          Text(
            status
                ? AppStrings.internetConnectionRestored
                : AppStrings.noInternetConnection,
          ),
        ],
      ),
      backgroundColor: status ? AppColors.success : AppColors.error,
      duration: Duration(seconds: status ? 2 : 5),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
