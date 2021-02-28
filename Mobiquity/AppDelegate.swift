//
//  AppDelegate.swift
//  Mobiquity
//
//  Created by Iuliia Korniichuk on 25.02.2021.
//

import UIKit
import FlickrKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private enum Constants {
        static let apiKey = "04556db74aafe128ef601b9d64dcd045"
        static let secret = "3839bf3af2a37e74"
    }
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigationManager = AppNavigationManager.shared
        navigationManager.apiManager = APIManager(flickrManager: getFlickrKit())
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationManager.navigation
        AppNavigationManager.shared.showGalleryScreen()
        window?.makeKeyAndVisible()

        return true
    }
    
    private func getFlickrKit() -> FlickrKit {
        let flickrManager = FlickrKit.shared()
        flickrManager.initialize(withAPIKey: Constants.apiKey, sharedSecret: Constants.secret)
        return flickrManager
    }

}

