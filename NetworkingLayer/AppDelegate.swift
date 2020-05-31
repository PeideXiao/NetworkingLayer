//
//  AppDelegate.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/12/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var allowRotation:Bool = false;
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
//        UINavigationBar.appearance().tintColor = UIColor.yellow;
//        UINavigationBar.appearance().backgroundColor = UIColor.red;
//        UINavigationBar.appearance().barTintColor = UIColor.green;
//        UINavigationBar.appearance().isTranslucent = true;
        
        
//        let appearance:UINavigationBarAppearance = UINavigationBarAppearance();
//        appearance.configureWithOpaqueBackground();
//        appearance.backgroundColor = .systemPink;
//
//        appearance.titleTextAttributes = [
//            NSAttributedString.Key.font:UIFont(name: "AvenirNext-DemiBold", size: 16) as Any,
//            NSAttributedString.Key.foregroundColor:UIColor.red
//
//        ];
//        appearance.buttonAppearance.normal.titleTextAttributes = [
//            NSAttributedString.Key.font:UIFont(name: "AvenirNext-DemiBold", size: 16) as Any,
//            NSAttributedString.Key.foregroundColor:UIColor.yellow
//        ];
//        UINavigationBar.appearance().standardAppearance = appearance;
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if (allowRotation) {
            return UIInterfaceOrientationMask.allButUpsideDown
        }
        else {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken);
    }
}

