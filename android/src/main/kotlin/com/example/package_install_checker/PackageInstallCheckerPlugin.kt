package com.example.package_install_checker

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** PackageInstallCheckerPlugin */
class PackageInstallCheckerPlugin :
    FlutterPlugin,
    MethodCallHandler {
    
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "package_install_checker")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "isPackageInstalled" -> {
                try {
                    val packageName = call.argument<String>("packageName")
                    
                    if (packageName.isNullOrEmpty()) {
                        result.error("INVALID_ARGUMENT", "Package name not provided", null)
                        return
                    }
                    
                    val isInstalled = checkPackageInstalled(packageName)
                    result.success(isInstalled)
                } catch (e: Exception) {
                    result.error("ERROR", "Error checking package: ${e.message}", e.toString())
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun checkPackageInstalled(packageName: String): Boolean {
        return try {
            val packageManager = context.packageManager
            
            // Method 1: Try getLaunchIntentForPackage (checks if app is launchable)
            val intent = packageManager.getLaunchIntentForPackage(packageName)
            if (intent != null) {
                return true
            }
            
            // Method 2: Try getPackageInfo (more comprehensive, checks if package exists at all)
            try {
                packageManager.getPackageInfo(packageName, 0)
                true
            } catch (e: Exception) {
                false
            }
        } catch (e: Exception) {
            // Return false if package not found or other exception occurs
            false
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
