# Package Install Checker

A Flutter plugin that checks if a specific package (app) is installed on an Android device.


## Supported Platforms

- ✅ Android
- ❌ iOS (not currently supported)

## Installation

```
flutter pub add package_install_checker
```

## Usage

### Android

Add the following `<queries>` element to your `AndroidManifest.xml` file:

```xml
<queries>
    <intent>
        <action android:name="android.intent.action.MAIN" />
        <category android:name="android.intent.category.LAUNCHER" />
    </intent>
</queries>
```

```dart
import 'package:package_install_checker/package_install_checker.dart';

// Check if a specific package is installed
bool isInstalled = await PackageInstallChecker.isPackageInstalled('com.android.chrome');
```

## Notes

- This package does not use the `QUERY_ALL_PACKAGES` permission, which can cause rejection during Play Store review.

## License

This project is distributed under the license terms.
