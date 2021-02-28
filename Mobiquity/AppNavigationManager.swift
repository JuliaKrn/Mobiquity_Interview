//
//  AppNavigationManager.swift
//  Mobiquity
//
//  Created by Iuliia Korniichuk on 25.02.2021.
//

import Foundation
import UIKit

final class AppNavigationManager {
    
    static let shared = AppNavigationManager()
    
    let navigation = UINavigationController()
    var apiManager: APIManagerProtocol?
    
    private init() {
        navigation.view.backgroundColor = .systemBackground
        
        UINavigationBar.appearance().tintColor = .systemIndigo
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemIndigo]
    }
    
    func showGalleryScreen() {
        guard let apiManager = apiManager else {
            return
        }
        
        let viewController = GalleryViewController()
        let viewModel = GalleryViewModel(view: viewController, apiManager: apiManager)
        viewController.viewModel = viewModel
        
        navigation.pushViewController(viewController, animated: true)
    }
    
}
