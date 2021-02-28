//
//  GalleryViewValuesMock.swift
//  MobiquityTests
//
//  Created by Iuliia Korniichuk on 28.02.2021.
//

import Foundation
import UIKit

class GalleryViewValuesMock: GalleryViewValuesProtocol {
    var screenName: String = "Test Gallery"
    var errorTitle: String = "Test title"
    var errorMessage: String = "Test msg"
    var photosToShow: [UIImage] = []
    
    init(loaded: Bool) {
        guard loaded else {
            return
        }
    
        guard let image = UIImage(named: "photo_placeholder_icon") else {
            return
        }
        
        photosToShow = Array(repeating: image, count: 4)
    }
}
