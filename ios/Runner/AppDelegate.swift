import Flutter
import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    
    // Register for remote notifications
    if #available(iOS 10.0, *) {
      // For iOS 10 and above, we need to comply with the UNUserNotificationCenter
      let center = UNUserNotificationCenter.current()
      center.delegate = self
      
      // Request permission
      let options: UNAuthorizationOptions = [.alert, .badge, .sound]
      center.requestAuthorization(options: options) { granted, error in
        if let error = error {
          print("Error requesting notification authorization: \(error)")
        } else if granted {
          print("Notification authorization granted")
        } else {
          print("Notification authorization denied")
        }
      }
    } else {
      // For iOS 9 and below
      let settings: UIUserNotificationSettings = UIUserNotificationSettings(
        types: [.alert, .badge, .sound],
        categories: nil
      )
      application.registerUserNotificationSettings(settings)
    }
    
    application.registerForRemoteNotifications()
    
    // Set Firebase Messaging delegate
    Messaging.messaging().delegate = self
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle device token registration
  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
  
  // Handle registration errors
  override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Failed to register for remote notifications: \(error)")
    super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
  }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate {
  // This function will be called when a notification is received while the app is in the foreground
  @available(iOS 10.0, *)
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    let userInfo = notification.request.content.userInfo
    
    // With FirebaseMessaging, we need to handle the message here
    Messaging.messaging().appDidReceiveMessage(userInfo)
    
    // Show the notification alert, badge, and sound
    completionHandler([[.alert, .badge, .sound]])
  }
  
  // This function will be called when a user taps on a notification
  @available(iOS 10.0, *)
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    let userInfo = response.notification.request.content.userInfo
    
    // With FirebaseMessaging, we need to handle the message here
    Messaging.messaging().appDidReceiveMessage(userInfo)
    
    completionHandler()
  }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")
    
    // Send token to your server if needed
    if let token = fcmToken {
      let dataDict: [String: String] = ["token": token]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
    }
  }
}
