import 'package:flutter/material.dart';
import 'package:flutterflare/core/configs/app_config.dart';

class FlavorBanner extends StatelessWidget {
  final Widget child;
  BannerConfig? bannerConfig;
  FlavorBanner({required this.child, this.bannerConfig});

  @override
  Widget build(BuildContext context) {
    if (AppConfig.environment == Environment.prod) return child;
    bannerConfig ??= _getDefaultBanner();
    return Stack(children: <Widget>[child, _buildBanner(context)]);
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
    return Container(
      width: 50,
      height: 50,
      child: CustomPaint(
        painter: BannerPainter(
          message: bannerConfig!.bannerName.toUpperCase(),
          textDirection: Directionality.of(context),
          layoutDirection: Directionality.of(context),
          location: BannerLocation.topStart,
          color: bannerConfig!.bannerColor,
        ),
      ),
    );
  }
}

class BannerConfig {
  final String bannerName;
  final Color bannerColor;
  BannerConfig({required this.bannerName, required this.bannerColor});
}
