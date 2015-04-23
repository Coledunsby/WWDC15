//
//  AppDelegate.swift
//  Cole Dunsby
//
//  Created by James Cole Dunsby on 2015-04-15.
//  Copyright (c) 2015 Cole Dunsby. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 18)!]
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold", size: 16)!], forState: .Normal)
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        NSNotificationCenter.defaultCenter().postNotificationName("applicationWillResignActive", object: nil)
    }

}

