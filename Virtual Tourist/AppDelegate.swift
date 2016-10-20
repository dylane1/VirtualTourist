//
//  AppDelegate.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 8/17/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let stack = CoreDataStack(modelName: "Model")!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Start Autosaving
        stack.autoSave(delayInSeconds: 60)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        stack.save()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        stack.save()
    }

//    func applicationWillEnterForeground(_ application: UIApplication) {
//        
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        
//    }
//
//    func applicationWillTerminate(_ application: UIApplication) {
//        
//    }
}

