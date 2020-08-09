//
//  AppDelegate.swift
//  CommonApp
//
//  Created by apple on 2020/8/9.
//  Copyright © 2020 aaronlee. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = BaseViewController()
        self.window?.makeKeyAndVisible()
        return true
    }


}

