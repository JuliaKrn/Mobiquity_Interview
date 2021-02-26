//
//  GalleryViewValues.swift
//  Mobiquity
//
//  Created by Iuliia Korniichuk on 25.02.2021.
//

import Foundation

protocol GalleryViewValuesProtocol {
    var screenName: String { get }
    
    var errorTitle: String { get }
    var errorMessage: String { get }
}

struct GalleryViewValues: GalleryViewValuesProtocol {
    let screenName: String
    
    let errorTitle: String
    let errorMessage: String
    
    init() {
        screenName = "Gallery"
        
        errorTitle = "Ooops!"
        errorMessage = "Sth went wrong :("
    }
}
