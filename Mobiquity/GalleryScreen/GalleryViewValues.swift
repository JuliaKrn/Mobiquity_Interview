//
//  GalleryViewValues.swift
//  Mobiquity
//
//  Created by Iuliia Korniichuk on 25.02.2021.
//

import Foundation
import UIKit

protocol GalleryViewValuesProtocol {
    var screenName: String { get }
    var errorTitle: String { get }
    var errorMessage: String { get }
    var photosToShow: [UIImage] { get set }
}

final class GalleryViewValues: GalleryViewValuesProtocol {
    let screenName: String
    let errorTitle: String
    let errorMessage: String
    var photosToShow: [UIImage] = []
    
    init() {
        screenName = "Gallery"
        errorTitle = "Ooops!"
        errorMessage = "Sth went wrong :("
    }
}
