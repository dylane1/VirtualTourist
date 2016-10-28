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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Start Autosaving
        Constants.coreDataStack.autoSave(delayInSeconds: 60)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        Constants.coreDataStack.save()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Constants.coreDataStack.save()
    }
}
