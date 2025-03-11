import 'package:flutter/material.dart';
import 'package:flutterflare/core/constants/app_images.dart';
import 'package:flutterflare/core/constants/app_sizes.dart';
import 'package:flutterflare/core/constants/app_strings.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Image(
            image: AssetImage(AppImages.error),
            height: AppSizes.s100,
          ),
          AppSizes.gapH20,
          Text(
            AppStrings.errorOccurred,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}
