import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package_install_checker_platform_interface.dart';

/// An implementation of [PackageInstallCheckerPlatform] that uses method channels.
class MethodChannelPackageInstallChecker extends PackageInstallCheckerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('package_install_checker');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<bool> isPackageInstalled(String packageName) async {
    try {
      final result = await methodChannel.invokeMethod<bool>(
        'isPackageInstalled',
        {'packageName': packageName},
      );
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('Error checking package installation: ${e.message}');
      return false;
    }
  }
}
