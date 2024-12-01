import Flutter
import UIKit
import flutter_local_notifications
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    var audioPlayer: AVAudioPlayer?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        // FLUTTER LOCAL NOTIFICATIONS

        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
            GeneratedPluginRegistrant.register(with: registry)
        }
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }

        // METHOD CHANNEL
        
        let controller = window?.rootViewController as! FlutterViewController
        let soundChannel = FlutterMethodChannel(name: "com.example.moblab/sound", binaryMessenger: controller.binaryMessenger)
        
        soundChannel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "playSound" {
                self?.playSound()
                result("Sound played!")
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func playSound() {
        if let soundURL = Bundle.main.url(forResource: "sound", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
