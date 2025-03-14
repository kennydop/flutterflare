import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflare/core/configs/flavor_banner.dart';
import 'package:flutterflare/core/constants/app_sizes.dart';
import 'package:flutterflare/core/constants/app_strings.dart';
import 'package:flutterflare/core/utils/device_utils.dart';
import 'package:device_info_plus/device_info_plus.dart';

// Dialog showing detailed device and app information
class DeviceInfoDialog extends StatelessWidget {
  final BannerConfig bannerConfig;
  const DeviceInfoDialog({Key? key, required this.bannerConfig})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(bottom: 10.0),
      title: Container(
        padding: const EdgeInsets.all(15.0),
        color: bannerConfig.bannerColor,
        child: const Text(
          AppStrings.deviceInfo,
          style: TextStyle(color: Colors.white),
        ),
      ),
      titlePadding: EdgeInsets.zero,
      content: _getContent(),
    );
  }

  Widget _getContent() {
    if (Platform.isAndroid) {
      return _androidContent();
    }
    if (Platform.isIOS) {
      return _iOSContent();
    }
    return const Text("You're not on Android or iOS");
  }

  Widget _iOSContent() {
    return FutureBuilder(
      future: DeviceUtils.iosDeviceInfo(),
      builder: (context, AsyncSnapshot<IosDeviceInfo> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: AppSizes.s120,
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        final device = snapshot.data!;
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTile('Flavor:', (appFlavor ?? 'dev').toUpperCase()),
              _buildTile('Build mode:', DeviceUtils.currentBuildMode().name),
              _buildTile('Physical device?:', '${device.isPhysicalDevice}'),
              _buildTile('Device:', device.name),
              _buildTile('Model:', device.model),
              _buildTile('System Name:', device.systemName),
              _buildTile('System Version:', device.systemVersion),
              _buildTile(
                'Identifier:',
                device.identifierForVendor ?? 'Unknown',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _androidContent() {
    return FutureBuilder(
      future: DeviceUtils.androidDeviceInfo(),
      builder: (context, AsyncSnapshot<AndroidDeviceInfo> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: AppSizes.s120,
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        final device = snapshot.data!;
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTile('Flavor:', (appFlavor ?? 'dev').toUpperCase()),
              _buildTile('Build mode:', DeviceUtils.currentBuildMode().name),
              _buildTile('Physical device?:', '${device.isPhysicalDevice}'),
              _buildTile('Manufacturer:', device.manufacturer),
              _buildTile('Model:', device.model),
              _buildTile('Android version:', device.version.release),
              _buildTile('Android SDK:', '${device.version.sdkInt}'),
              _buildTile('Board:', device.board),
              _buildTile('Bootloader:', device.bootloader),
              _buildTile('Brand:', device.brand),
              _buildTile('Device:', device.device),
              _buildTile('Display:', device.display),
              _buildTile('Fingerprint:', device.fingerprint),
              _buildTile('Hardware:', device.hardware),
              _buildTile('Host:', device.host),
              _buildTile('ID:', device.id),
              _buildTile('Product:', device.product),
              _buildTile('Type:', device.type),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTile(String key, String value) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              key,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
