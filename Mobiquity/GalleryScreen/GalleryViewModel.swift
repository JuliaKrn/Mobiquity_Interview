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
    func loadMorePhotos()
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
    
    var apiManager: APIManagerProtocol
    
    init(view: GalleryViewProtocol, apiManager: APIManagerProtocol, additionalManagers: Any? = nil) {
        self.view = view
        self.apiManager = apiManager
        
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
    
    func loadMorePhotos() {
        viewState = .loading(viewValues)
        
        apiManager.fetchDefaultPhotos { (images) in
            self.viewValues.photosToShow = images
            self.viewState = .loaded(self.viewValues)
        }
    }
}

extension GalleryViewModel {
    
    private func fetchDefaultPhotos() {
      //  apiManager.fetchInterestingPhotos()
        // TODO: add loading photos of the day
        viewState = .loading(viewValues)
        
        apiManager.fetchDefaultPhotos { (images) in
            self.viewValues.photosToShow = images
            self.viewState = .loaded(self.viewValues)
        }
    }
    
    private func updateLatestSearchList(with theme: String) {
        // TODO: add list of recently looked for themes
    }
    
}


