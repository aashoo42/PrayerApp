//
//  AppDelegate.swift
//  PrayerApp
//
//  Created by mac on 4/4/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    // MARK:- Alerts
    func showInternetAlert(){
        let alert = UIAlertController.init(title: "Internet?", message: "Please check your internet connection.", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func showErroAlert(alertMsg: String){
        let alert = UIAlertController.init(title: "Error", message: alertMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

