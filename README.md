# Package Install Checker

A Flutter plugin that checks if a specific package (app) is installed on an Android device.

## Installation

```
flutter pub add package_install_checker
```

## Usage

### Android

```xml
<!-- write queries -->
<intent>
    <action android:name="android.intent.action.MAIN" />
    <category android:name="android.intent.category.LAUNCHER" />
</intent>
```

```dart
import 'package:package_install_checker/package_install_checker.dart';

// Check if a specific package is installed
bool isInstalled = await PackageInstallChecker.isPackageInstalled('com.android.chrome');
```

### Supported Platforms

- ✅ Android
- ❌ iOS (not currently supported)

## License

This project is distributed under the license terms.
