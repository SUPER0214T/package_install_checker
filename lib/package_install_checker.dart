import 'package_install_checker_platform_interface.dart';

class PackageInstallChecker {
  static Future<String?> getPlatformVersion() {
    return PackageInstallCheckerPlatform.instance.getPlatformVersion();
  }

  static Future<bool> isPackageInstalled(String packageName) {
    return PackageInstallCheckerPlatform.instance.isPackageInstalled(
      packageName,
    );
  }
}
