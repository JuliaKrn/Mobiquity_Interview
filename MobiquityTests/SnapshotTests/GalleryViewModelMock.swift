//
//  GalleryViewModelMock.swift
//  MobiquityTests
//
//  Created by Iuliia Korniichuk on 28.02.2021.
//

import Foundation

class GalleryViewModelMock: GalleryViewModelProtocol {
    
    var viewState: ViewState<GalleryViewValuesProtocol>
    var viewValues: GalleryViewValuesProtocol
    var updateValues: (() -> Void) = { }
    
    func didChoseTheme(_ theme: String) { }
    func loadMorePhotos() { }
    func getSearchList() -> [String]? {
        nil
    }
    
    init(loaded: Bool) {
        viewValues = GalleryViewValuesMock(loaded: loaded)
        viewState = loaded ? .loaded(viewValues) : .loading(viewValues)
    }
    
}
