import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import AudioToolbox
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  
  var audioPlayer: AVAudioPlayer?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
      
      // Audio session ayarla
      do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
        try AVAudioSession.sharedInstance().setActive(true)
      } catch {
        print("❌ Audio session hatası: \(error)")
      }
      
      // Bildirim izinlerini iste
      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
      } else {
        let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
      }
      
      application.registerForRemoteNotifications()

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // APNS token alındığında
  override func application(_ application: UIApplication, 
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("📱 APNS token received: \(deviceToken)")
    
    // Firebase Messaging'e APNS token'ı bildir
    Messaging.messaging().apnsToken = deviceToken
  }
  
  // APNS token alınamazsa
  override func application(_ application: UIApplication, 
                            didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Failed to register for remote notifications: \(error)")
  }
  
  // Özel sesi çal
  private func playCustomSound() {
    guard let soundURL = Bundle.main.url(forResource: "notification", withExtension: "caf") else {
      print("❌ notification.caf dosyası bulunamadı!")
      // Alternatif olarak sound1.caf'ı dene
      if let altURL = Bundle.main.url(forResource: "sound1", withExtension: "caf") {
        print("✅ sound1.caf bulundu, çalınıyor...")
        playSound(url: altURL)
      }
      return
    }
    print("✅ notification.caf bulundu, çalınıyor...")
    playSound(url: soundURL)
  }
  
  private func playSound(url: URL) {
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: url)
      audioPlayer?.prepareToPlay()
      audioPlayer?.play()
      print("🔊 Ses çalınıyor!")
    } catch {
      print("❌ Ses çalma hatası: \(error)")
    }
  }
  
  // Bildirim geldiğinde (foreground)
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    
    print("📱 Foreground bildirim alındı: \(notification.request.content.title)")
    print("📦 UserInfo: \(userInfo)")
    
    // Özel sesi manuel olarak çal
    playCustomSound()
    
    // iOS 14+ için banner, liste ve badge göster (ses manuel çalınıyor)
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .list, .badge])
    } else {
      completionHandler([.alert, .badge])
    }
  }
  
  // Bildirime tıklandığında
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
    completionHandler()
  }
}
