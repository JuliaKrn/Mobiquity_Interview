//
//  GalleryViewModel.swift
//  Mobiquity
//
//  Created by Iuliia Korniichuk on 25.02.2021.
//

import Foundation

protocol GalleryViewModelProtocol {
    var viewState: ViewState<GalleryViewValuesProtocol> { get }
    var viewValues: GalleryViewValuesProtocol { get }
    
    var updateValues: (() -> Void) { get set }
    
    func didChoseTheme(_ theme: String)
}

class GalleryViewModel: GalleryViewModelProtocol {
    
    var viewState: ViewState<GalleryViewValuesProtocol> {
        didSet {
            self.updateValues()
        }
    }
    
    var view: GalleryViewProtocol
    var viewValues: GalleryViewValuesProtocol
    var updateValues: (() -> Void) = { }
    
    init(view: GalleryViewProtocol, additionalManagers: Any? = nil) {
        self.view = view
        
        viewValues = GalleryViewValues()
        viewState = .loading(viewValues)
        
        fetchDefaultPhotos()
    }
    
    func didChoseTheme(_ theme: String) {
        // TODO: start load
    }
    
    func didStartSearch() {
        // TODO: will be called when user starts typing
    }
}

extension GalleryViewModel {
    
    private func fetchDefaultPhotos() {
        // TODO: add loading photos of the day
    }
    
    private func updateLatestSearchList(with theme: String) {
        // TODO: add list of recently looked for themes
    }
    
}


