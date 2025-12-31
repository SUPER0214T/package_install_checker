
import 'package_install_checker_platform_interface.dart';

class PackageInstallChecker {
  Future<String?> getPlatformVersion() {
    return PackageInstallCheckerPlatform.instance.getPlatformVersion();
  }
}
