//
//  AppDelegate.swift
//  Finder
//
//  Created by Nicolas Porpiglia on 6/10/17.
//  Copyright © 2017 Nicolas Porpiglia. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configureFirebase()
       
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        
        
        
        NotificationManager.shared.listen("idgeneradofirebase", success: { (result) in
            
            //let timeInterval = Date().timeIntervalSinceNow
            // if timeInterval > result.timeInterval {
                // create a corresponding local notification
                let notification = UILocalNotification()
                notification.alertBody = "Good news: \(result.name) found your kid. You can reach him at \(result.phone)"
                notification.alertAction = "open"
                notification.fireDate = Date()
                UIApplication.shared.scheduleLocalNotification(notification)
            //}
            
        }) { (error) in
            print("error")
        }
        
        UserManager.shared.currentUser = User(family: nil,
                                              name: "Matias Tripode",
                                              phone: "206-345-2354",
                                              galleryName: "20170610Globant")
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        var initialViewController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
        
        if let phone = UserDefaults.standard.object(forKey: "userPhone") as? String {
            UserManager.shared.currentUser = User(family: nil,
                                                  name: "Matias Tripode",
                                                  phone: phone,
                                                  galleryName: "globant123")
            
        } else {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        }
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func configureFirebase() {
        FirebaseApp.configure()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

