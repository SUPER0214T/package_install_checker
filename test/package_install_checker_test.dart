import 'package:flutter_test/flutter_test.dart';
import 'package:package_install_checker/package_install_checker.dart';
import 'package:package_install_checker/package_install_checker_platform_interface.dart';
import 'package:package_install_checker/package_install_checker_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPackageInstallCheckerPlatform
    with MockPlatformInterfaceMixin
    implements PackageInstallCheckerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PackageInstallCheckerPlatform initialPlatform = PackageInstallCheckerPlatform.instance;

  test('$MethodChannelPackageInstallChecker is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPackageInstallChecker>());
  });

  test('getPlatformVersion', () async {
    PackageInstallChecker packageInstallCheckerPlugin = PackageInstallChecker();
    MockPackageInstallCheckerPlatform fakePlatform = MockPackageInstallCheckerPlatform();
    PackageInstallCheckerPlatform.instance = fakePlatform;

    expect(await packageInstallCheckerPlugin.getPlatformVersion(), '42');
  });
}
