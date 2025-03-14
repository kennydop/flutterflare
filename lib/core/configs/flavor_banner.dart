import 'package:flutter/material.dart';
import 'package:flutterflare/core/configs/app_config.dart';
import 'package:flutterflare/core/constants/app_sizes.dart';
import 'package:flutterflare/shared/widgets/device_info_dialog.dart';

class FlavorBanner extends StatelessWidget {
  final Widget child;
  BannerConfig? bannerConfig;
  FlavorBanner({required this.child, this.bannerConfig});

  @override
  Widget build(BuildContext context) {
    if (AppConfig.environment == Environment.prod) return child;
    bannerConfig ??= _getDefaultBanner();
    return Stack(
      textDirection: TextDirection.ltr,
      children: <Widget>[child, _buildBanner(context)],
    );
  }

  BannerConfig _getDefaultBanner() {
    return BannerConfig(
      bannerName: AppConfig.environment.name,
      bannerColor:
          AppConfig.environment == Environment.prod
              ? Colors.green
              : AppConfig.environment == Environment.staging
              ? Colors.purple
              : Colors.blue,
    );
  }

  Widget _buildBanner(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        width: AppSizes.s50,
        height: AppSizes.s50,
        child: CustomPaint(
          painter: BannerPainter(
            message: bannerConfig!.bannerName.toUpperCase(),
            textDirection: Directionality.of(context),
            layoutDirection: Directionality.of(context),
            location: BannerLocation.topStart,
            color: bannerConfig!.bannerColor,
          ),
        ),
      ),
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DeviceInfoDialog(bannerConfig: bannerConfig!);
          },
        );
      },
    );
  }
}

class BannerConfig {
  final String bannerName;
  final Color bannerColor;
  BannerConfig({required this.bannerName, required this.bannerColor});
}
