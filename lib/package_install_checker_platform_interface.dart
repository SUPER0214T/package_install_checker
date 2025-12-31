import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'package_install_checker_method_channel.dart';

abstract class PackageInstallCheckerPlatform extends PlatformInterface {
  /// Constructs a PackageInstallCheckerPlatform.
  PackageInstallCheckerPlatform() : super(token: _token);

  static final Object _token = Object();

  static PackageInstallCheckerPlatform _instance = MethodChannelPackageInstallChecker();

  /// The default instance of [PackageInstallCheckerPlatform] to use.
  ///
  /// Defaults to [MethodChannelPackageInstallChecker].
  static PackageInstallCheckerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PackageInstallCheckerPlatform] when
  /// they register themselves.
  static set instance(PackageInstallCheckerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
