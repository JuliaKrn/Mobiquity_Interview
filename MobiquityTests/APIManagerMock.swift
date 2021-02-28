//
//  APIManagerMock.swift
//  MobiquityTests
//
//  Created by Iuliia Korniichuk on 28.02.2021.
//

import Foundation
import UIKit

class APIManagerMock: APIManagerProtocol {
    func fetchDefaultPhotos(completion: @escaping ([UIImage], Bool) -> Void) {
        completion(getDefaultPhotoArray(), true)
    }
    
    func fetchThemedPhotos(theme: String, completion: @escaping ([UIImage], Bool) -> Void) {
        completion(getThemedPhotoArray(), true)
    }
    
    func reset() { }
    
    private func getDefaultPhotoArray() -> [UIImage] {
        guard let image = UIImage(named: "photo_placeholder_icon") else {
            return []
        }
        
        return Array(repeating: image, count: 4)
    }
    
    private func getThemedPhotoArray() -> [UIImage] {
        guard let image = UIImage(named: "photo_placeholder_icon") else {
            return []
        }
        
        return Array(repeating: image, count: 2)
    }
}

