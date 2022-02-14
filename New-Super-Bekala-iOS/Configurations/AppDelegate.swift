//
//  AppDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Super Bekala on 7/8/20.
//  Copyright © 2020 Super Bekala. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import SVProgressHUD
//import GoogleMaps
//import GooglePlaces
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import CoreData
import Reachability
import PusherSwift
import AVFoundation
import NotificationBannerSwift
import FirebaseDynamicLinks

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var presenter: MainPresenter?
    let reachability = try! Reachability()
    static var pusher: Pusher!
    static var channel: PusherChannel!
    static var player: AVAudioPlayer?
    static var standard: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
                
        FirebaseApp.configure()
        Auth.auth().canHandle(URL(string: "com.googleusercontent.apps.966110321537-bg6q76idnnvqf2fdvu9fstertat6mgq1")!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch { }
                
//        GMSServices.provideAPIKey("AIzaSyCyAPJ2M7dyEAyC33zqVCyXlWlWRszYH4U")
//        GMSPlacesClient.provideAPIKey("AIzaSyCyAPJ2M7dyEAyC33zqVCyXlWlWRszYH4U")
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(ChatVC.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(PhoneVC.self)
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(VerifyPhoneVC.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(VerifyPhoneVC.self)
        
       // Auth.auth().canHandle(URL(string: "com.googleusercontent.apps.966110321537-bg6q76idnnvqf2fdvu9fstertat6mgq1")!)
        
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setCornerRadius(10)
        SVProgressHUD.setMinimumSize(CGSize(width: 75, height: 75))
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.75))
        
        //GIDSignIn.sharedInstance.clientID = FirebaseApp.app()?.options.clientID
       // GIDSignIn.sharedInstance.delegate = self
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
          
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?,
                     annotation: Any) -> Bool {
      if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
        // Handle the deep link. For example, show the deep-linked content or
        // apply a promotional offer to the user's account.
        // [START_EXCLUDE]
        // In this sample, we just open an alert.
        handleDynamicLink(dynamicLink)
        // [END_EXCLUDE]
        return true
      }
      // [START_EXCLUDE silent]
      // Show the deep link that the app was called with.
      showDeepLinkAlertView(withMessage: "openURL:\n\(url)")
      // [END_EXCLUDE]
      return false
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {


        if let incomingLink  = userActivity.webpageURL {
            print("incomingLink is : \(incomingLink)")
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingLink) { (dynamiclink, error) in
                guard error == nil else {
                    print("error IS :\(error?.localizedDescription)")
                    return
                }
                if let dynamiclink = dynamiclink {
                    guard let url = dynamiclink.url else {
                        print("Not Contains Url")
                        return
                    }
                    print("your incoming is : \(url.absoluteString)")
                    guard let urls = URLComponents(string: url.absoluteString) else { return }
                }
            }
            return linkHandled
        }
        return false
    }
    
    func handleDynamicLink(_ dynamicLink: DynamicLink) {
        let matchConfidence: String
        if dynamicLink.matchType == .weak {
          matchConfidence = "Weak"
        } else {
          matchConfidence = "Strong"
        }
        let message = "App URL: \(dynamicLink.url?.absoluteString ?? "")\n" +
          "Match Confidence: \(matchConfidence)\nMinimum App Version: \(dynamicLink.minimumAppVersion ?? "")"
        showDeepLinkAlertView(withMessage: message)
      }
 
      func showDeepLinkAlertView(withMessage message: String) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let alertController = UIAlertController(
          title: "Deep-link Data",
          message: message,
          preferredStyle: .alert
        )
        alertController.addAction(okAction)
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
      }
    
    @objc func reachabilityChanged(note: Notification){
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .unavailable:
            Router.toNoConnection(self.window?.rootViewController)
        default:
            break
        }
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Cart")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
}

//extension AppDelegate: GIDSignInDelegate{
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        guard error == nil else{ return }
//        guard let authentication = user.authentication else { return }
//        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                       accessToken: authentication.accessToken)
//        NotificationCenter.default.post(name: NSNotification.Name("GoogleCredential"), object: nil, userInfo: ["GoogleCredential": credential])
//    }
//    
//    
//}

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate{
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //Auth.auth().setAPNSToken(deviceToken, type: .prod)
        Messaging.messaging().apnsToken = deviceToken
    }

//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .sound, .badge])
//
//    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let actionIdentifier = response.actionIdentifier

        switch actionIdentifier {
        case UNNotificationDismissActionIdentifier: // Notification was dismissed by user
            completionHandler()
        case UNNotificationDefaultActionIdentifier: // App was opened from notification
        
            let userInfo = response.notification.request.content.userInfo
            print("userInfo",userInfo)
            
            guard
            let aps = userInfo[AnyHashable("aps")] as? NSDictionary,
            let alert = aps["alert"] as? NSDictionary,
            let title = alert["title"] as? String,
            let _ = alert["body"] as? String
            else { return }
            
            let topVC = UIApplication.getTopViewController()
            
            if let orderId = userInfo["order_id"] as? String{
                self.presenter = MainPresenter(self)
                self.presenter?.getOrderBy(Int(orderId)!)
            }
            
            if title.lowercased().contains("new message") || title.lowercased().contains("رسالة جديدة"){
                if !topVC!.isKind(of: ChatVC.self){
                    Shared.isChatting = false
                    NotificationCenter.default.post(name: NSNotification.Name("is_chatting"), object: nil)
                    Router.toChat(UIApplication.getTopViewController()!)
                }
            }

            completionHandler()
        default:
            completionHandler()
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
                        
        print("userInfo",userInfo)
        
        guard
            let aps = userInfo[AnyHashable("aps")] as? NSDictionary,
            let alert = aps["alert"] as? NSDictionary,
            let body = alert["body"] as? String,
            let title = alert["title"] as? String
        else { return }
        
        guard !title.lowercased().contains("new message"), !title.lowercased().contains("رسالة جديدة") else { return }
        
        let banner = FloatingNotificationBanner(title: title,
                                                subtitle: body,
                                                titleColor: .black,
                                                subtitleColor: .black,
                                                style: .info)
        banner.backgroundColor = .white
        banner.onSwipeUp = { banner.dismiss() }
        banner.autoDismiss = true
        banner.show(
            bannerPosition: .top,
            queue: .default,
            edgeInsets: UIEdgeInsets(top: 12, left: 15, bottom: 0, right: 15),
            cornerRadius: 7,
            shadowColor: .lightGray, shadowOpacity: 0.5, shadowBlurRadius: 5, shadowCornerRadius: 3, shadowOffset: .zero)
        banner.onTap = {
            if let orderId = userInfo["order_id"] as? String{
                self.presenter = MainPresenter(self)
                self.presenter?.getOrderBy(Int(orderId)!)
            }
        }
        
        Shared.play("message_notify_tone", &AppDelegate.player)
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcmTokenHere",fcmToken)
        UserDefaults.init().set(fcmToken, forKey: "FCM_Token")
    }
    
    
}


extension AppDelegate: MainViewDelegate{
    func didCompleteWithOrder(_ data: LastOrder?) {
        guard let data = data else { return }
        Router.toOrder(UIApplication.getTopViewController()!, data)
    }
}

