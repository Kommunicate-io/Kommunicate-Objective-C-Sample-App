//
//  KommunicateWrapper.swift
//  KommunicateObjcSample
//
//  Created by Mukesh Thawani on 04/10/18.
//  Copyright © 2018 mukesh. All rights reserved.
//

import Foundation
import Kommunicate
import UserNotifications

@objc public class KommunicateWrapper: NSObject {

    @objc public static let shared = KommunicateWrapper()

    @objc func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {

        print("DEVICE_TOKEN_DATA :: \(deviceToken.description)")  // (SWIFT = 3) : TOKEN PARSING

        var deviceTokenString: String = ""
        for i in 0..<deviceToken.count
        {
            deviceTokenString += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        print("DEVICE_TOKEN_STRING :: \(deviceTokenString)")

        if (KMUserDefaultHandler.getApnDeviceToken() != deviceTokenString)
        {
            let kmRegisterUserClientService: KMRegisterUserClientService = KMRegisterUserClientService()
            kmRegisterUserClientService.updateApnDeviceToken(withCompletion: deviceTokenString, withCompletion: { (response, error) in
                print ("REGISTRATION_RESPONSE :: \(String(describing: response))")
            })
        }
    }

    @objc func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler
        completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Received notification With Completion :: \(userInfo.description)")
        let kmPushNotificationService: KMPushNotificationService = KMPushNotificationService()
        kmPushNotificationService.notificationArrived(to: application, with: userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }

    @objc func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        registerForNotification()

        KMPushNotificationHandler.shared.dataConnectionNotificationHandlerWith(KMConfiguration())
        let kmApplocalNotificationHandler : KMAppLocalNotification =  KMAppLocalNotification.appLocalNotificationHandler()
        kmApplocalNotificationHandler.dataConnectionNotificationHandler()

        if (launchOptions != nil)
        {
            let dictionary = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary

            if (dictionary != nil)
            {
                print("launched from push notification")
                let kmPushNotificationService: KMPushNotificationService = KMPushNotificationService()

                let appState: NSNumber = NSNumber(value: 0 as Int32)
                let kommunicateProcessed = kmPushNotificationService.processPushNotification(launchOptions,updateUI:appState)
                if !kommunicateProcessed {
                    //Note: notification for app
                }
            }
        }
        return true
    }

    @objc func applicationDidEnterBackground(_ application: UIApplication) {
        print("APP_ENTER_IN_BACKGROUND")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "APP_ENTER_IN_BACKGROUND"), object: nil)
    }

    @objc func applicationWillEnterForeground(_ application: UIApplication) {
        KMPushNotificationService.applicationEntersForeground()
        print("APP_ENTER_IN_FOREGROUND")

        NotificationCenter.default.post(name: Notification.Name(rawValue: "APP_ENTER_IN_FOREGROUND"), object: nil)
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    @objc func applicationWillTerminate(application: UIApplication) {
        KMDbHandler.sharedInstance().saveContext()
    }

    @objc func connectUser(userId: String,
                           password: String? = nil,
                           displayName: String? = nil,
                           emailId: String? = nil,
                           applicationId: String,
                           completion : @escaping (_ response: String?, _ error: NSError?) -> Void) {
        guard let user = KMUser(userId: userId, password: password, email: emailId, andDisplayName: displayName) else {
            completion(nil, NSError(domain: "KMUserGeneration", code: 111, userInfo: nil))
            return
        }
        Kommunicate.registerUser(user) { (response, error) in
            if error == nil {
                completion(response?.userKey, nil)
            } else {
                completion(nil, error)
            }
        }
    }

    func registerForNotification() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in

                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            // Fallback on earlier versions
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()

        }
    }
}
