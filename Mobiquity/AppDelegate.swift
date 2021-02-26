//
//  AppDelegate.swift
//  Mobiquity
//
//  Created by Iuliia Korniichuk on 25.02.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = AppNavigationManager.shared.navigation
        AppNavigationManager.shared.showGalleryScreen()
        window?.makeKeyAndVisible()

        return true
    }

}

