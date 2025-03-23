import 'package:flutter/material.dart';
import 'package:flutterflare/core/constants/app_images.dart';
import 'package:flutterflare/core/constants/app_sizes.dart';
import 'package:flutterflare/core/constants/app_strings.dart';

class AppErrorWidget extends StatelessWidget {
  final String? error;
  const AppErrorWidget({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Image(
              image: AssetImage(AppImages.error),
              height: AppSizes.s100,
            ),
            AppSizes.gapH20,
            Text(
              error ?? AppStrings.errorOccurred,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
