//
//  AppDelegate.swift
//  TypographyKit
//
//  Created by Ross Butler on 05/09/2017.
//  Copyright (c) 2017 Ross Butler. All rights reserved.
//

import UIKit
import TypographyKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication, didFinishLaunchingWithOptions
                              launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Replace bundle URL with remote URL - TypographyKit will find TypographyKit.json in the bundle by default.
        let configurationURL = Bundle.main.url(forResource: "TypographyKit", withExtension: "json")
        // For apps supporting iOS 11 & 12, otherwise use async / await versions of this method.
        TypographyKit.configure(
            with: TypographyKitConfiguration.default
                .setConfigurationURL(configurationURL)
        )
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}
