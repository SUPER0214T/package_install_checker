import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:package_install_checker/package_install_checker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  bool? _isInstalled;
  final _packageNameController = TextEditingController(
    text: 'com.android.chrome', // Default test package
  );

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    _packageNameController.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await PackageInstallChecker.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> checkPackage() async {
    final packageName = _packageNameController.text.trim();

    if (packageName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a package name')),
      );
      return;
    }

    try {
      final isInstalled = await PackageInstallChecker.isPackageInstalled(
        packageName,
      );
      setState(() {
        _isInstalled = isInstalled;
      });
    } on PlatformException catch (e) {
      setState(() {
        _isInstalled = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Package Install Checker')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Running on: $_platformVersion',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _packageNameController,
                decoration: const InputDecoration(
                  labelText: 'Package Name',
                  hintText: 'com.example.app',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: checkPackage,
                child: const Text('Check Installation'),
              ),
              const SizedBox(height: 32),
              if (_isInstalled != null)
                Card(
                  color: _isInstalled!
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          _isInstalled! ? Icons.check_circle : Icons.cancel,
                          color: _isInstalled! ? Colors.green : Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isInstalled!
                              ? 'Package is installed ✓'
                              : 'Package is NOT installed ✗',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: _isInstalled!
                                    ? Colors.green.shade900
                                    : Colors.red.shade900,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              const Divider(),
              const Text(
                'Common packages to test:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildQuickTestChip('com.android.chrome'),
                  _buildQuickTestChip('com.google.android.gm'),
                  _buildQuickTestChip('com.whatsapp'),
                  _buildQuickTestChip('com.fake.package.notexist'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickTestChip(String packageName) {
    return ActionChip(
      label: Text(packageName, style: const TextStyle(fontSize: 11)),
      onPressed: () {
        _packageNameController.text = packageName;
        checkPackage();
      },
    );
  }
}
