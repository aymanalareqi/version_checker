package com.smartfingers.version_checker

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.content.Context
import android.content.pm.PackageManager

/** VersionCheckerPlugin */
class VersionCheckerPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "version_checker")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "getAppVersion" -> {
        try {
          val packageInfo = context.packageManager.getPackageInfo(context.packageName, 0)
          val versionName = packageInfo.versionName
          val versionCode = packageInfo.longVersionCode.toString()
          
          val versionInfo = mapOf(
            "version" to versionName,
            "buildNumber" to versionCode
          )
          result.success(versionInfo)
        } catch (e: PackageManager.NameNotFoundException) {
          result.error("VERSION_ERROR", "Could not get app version", null)
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
