import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

// Enum representing the different build modes
enum BuildMode { DEBUG, PROFILE, RELEASE }

// Utility class for device and environment information
class DeviceUtils {
  // Determines the current build mode (DEBUG, PROFILE or RELEASE)
  static BuildMode currentBuildMode() {
    if (const bool.fromEnvironment('dart.vm.product')) {
      return BuildMode.RELEASE;
    }
    var result = BuildMode.PROFILE;
    // Little trick, since assert only runs on DEBUG mode
    assert(() {
      result = BuildMode.DEBUG;
      return true;
    }());
    return result;
  }

  // Get Android device information
  static Future<AndroidDeviceInfo> androidDeviceInfo() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    return plugin.androidInfo;
  }

  // Get iOS device information
  static Future<IosDeviceInfo> iosDeviceInfo() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    return plugin.iosInfo;
  }
}
