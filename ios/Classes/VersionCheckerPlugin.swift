import Flutter
import UIKit

public class VersionCheckerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "version_checker", binaryMessenger: registrar.messenger())
    let instance = VersionCheckerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "getAppVersion":
      if let infoDictionary = Bundle.main.infoDictionary,
         let version = infoDictionary["CFBundleShortVersionString"] as? String,
         let buildNumber = infoDictionary["CFBundleVersion"] as? String {
        
        let versionInfo: [String: String] = [
          "version": version,
          "buildNumber": buildNumber
        ]
        result(versionInfo)
      } else {
        result(FlutterError(code: "VERSION_ERROR", message: "Could not get app version", details: nil))
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
