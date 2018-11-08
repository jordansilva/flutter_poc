import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(_ application: UIApplication,
                            didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController;
        let batteryChannel = FlutterMethodChannel.init(name: "samples.flutter.io/battery", binaryMessenger: controller);
        let webViewChannel = FlutterMethodChannel.init(name: "samples.flutter.io/webview", binaryMessenger: controller);
        
        //let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil);
        //_ = mainStoryBoard.instantiateViewController(withIdentifier: "FlutterViewController");
        
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        self.window?.rootViewController = initialViewController
//        self.window?.makeKeyAndVisible()
        
        batteryChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            if ("getBatteryLevel" == call.method) {
                self.receiveBatteryLevel(result: result);
            } else {
                result(FlutterMethodNotImplemented);
            }
        });
        
        webViewChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            switch call.method {
                case "openWebView":
                    
                    break;
                default:
                    break;
            }
        })
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
    private func receiveBatteryLevel(result: FlutterResult) {
        let device = UIDevice.current;
        device.isBatteryMonitoringEnabled = true;
        if (device.batteryState == UIDeviceBatteryState.unknown) {
            result(FlutterError.init(code: "UNAVAILABLE",
                                     message: "Battery info unavailable",
                                     details: nil));
        } else {
            result(Int(device.batteryLevel * 100));
        }
    }
}
