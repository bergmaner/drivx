import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyBXwNnIlA2i83rdz7vdq2il8Jc8hzBoVAU")
    GeneratedPluginRegistrant.screens.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
