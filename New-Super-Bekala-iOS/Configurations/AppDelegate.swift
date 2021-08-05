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
import GoogleMaps
import GooglePlaces
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import CoreData
import Reachability
import PusherSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let reachability = try! Reachability()
    static var pusher: Pusher!
    static var channel: PusherChannel!
    static var standard: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch { }
        
        
        GMSServices.provideAPIKey("AIzaSyCyAPJ2M7dyEAyC33zqVCyXlWlWRszYH4U")
        GMSPlacesClient.provideAPIKey("AIzaSyCyAPJ2M7dyEAyC33zqVCyXlWlWRszYH4U")
        
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
       // Auth.auth().canHandle(URL(string: "com.googleusercontent.apps.966110321537-bg6q76idnnvqf2fdvu9fstertat6mgq1")!)
        Auth.auth().canHandle(URL(string: "com.googleusercontent.apps.806574922305-8f0bnjog7kriohcipdf2ilu7jb4b7sch")!)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultAnimationType(.native)
       // SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setCornerRadius(10)
        SVProgressHUD.setMinimumSize(CGSize(width: 75, height: 75))
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.75))
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
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
    
    @objc func reachabilityChanged(note: Notification){
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .unavailable:
            Router.toNoConnection(self.window?.rootViewController)
        default:
            break
        }
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    -> Bool {        
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Cart")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
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

extension AppDelegate: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else{ return }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        print(user.profile)
        
        NotificationCenter.default.post(name: NSNotification.Name("GoogleCredential"), object: nil, userInfo: ["GoogleCredential": credential])
        
    }
    
    
}

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate{
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
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
            // Do something
            completionHandler()
        case UNNotificationDefaultActionIdentifier: // App was opened from notification
            // Do something
            
            let userInfo = response.notification.request.content.userInfo
            print("userInfo",userInfo)
            
            let navController = self.window?.rootViewController as! UINavigationController
            NotificationCenter.default.post(name: NSNotification.Name("ReceivedOrderFromFCM"), object: nil, userInfo: userInfo)
            
            completionHandler()
        default:
            completionHandler()
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
                        
        let navController = self.window?.rootViewController as! UINavigationController
        NotificationCenter.default.post(name: NSNotification.Name("ReceivedOrderFromFCM"), object: nil, userInfo: userInfo)
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("fcmTokenHere",fcmToken)
        UserDefaults.init().set(fcmToken, forKey: "FCM_Token")
    }
    
    
}
