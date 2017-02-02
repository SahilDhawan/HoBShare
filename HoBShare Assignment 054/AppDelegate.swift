//
//  AppDelegate.swift
//  HoBShare Assignment 054
//
//  Created by Sahil Dhawan on 15/01/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func applicationDidFinishLaunching(application: UIApplication) {
        if NSUserDefaults.standardUserDefaults().objectForKey("MyHobbies") == nil
        {
            let myHobbies = [Hobby(hobbyName:"Video Games"),Hobby(hobbyName:"Apple"),Hobby(hobbyName:"Computers")]
            let HobbyData = NSKeyedArchiver.archivedDataWithRootObject(myHobbies)
//            let HobbyData = NSKeyedArchiver.archivedData(withRootObject: myHobbies)
            NSUserDefaults.standardUserDefaults().registerDefaults(["MyHobbies":HobbyData])
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        if NSUserDefaults.standardUserDefaults().objectForKey("CurrentUserId") == nil
            //            .object(forKey: "CurrentUserId")==nil
        {
            NSUserDefaults.standardUserDefaults().registerDefaults(["CurrentUserId":""])
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
//        return true
    }
//        func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        
//    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

