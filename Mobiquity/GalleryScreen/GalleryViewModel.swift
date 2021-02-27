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
    
    private enum ViewThemeType {
        case `default`
        case theme(String)
    }
    
    // MARK: Properties
    var viewState: ViewState<GalleryViewValuesProtocol> {
        didSet {
            self.updateValues()
        }
    }

    let view: GalleryViewProtocol
    var viewValues: GalleryViewValuesProtocol
    var updateValues: (() -> Void) = { }
    
    private let apiManager: APIManagerProtocol
    
    private var viewTheme: ViewThemeType {
        didSet {
            apiManager.reset()
        }
    }
    
    // MARK: Public Methods
    init(view: GalleryViewProtocol, apiManager: APIManagerProtocol, additionalManagers: Any? = nil) {
        self.view = view
        self.apiManager = apiManager
        
        viewValues = GalleryViewValues()
        viewState = .loading(viewValues)
        
        viewTheme = .default
        fetchDefaultPhotos()
    }
    
    func didChoseTheme(_ theme: String) {
        viewTheme = .theme(theme)
        fetchThemedPhotos(theme: theme)
    }
    
    func didStartSearch() {
        // TODO: will be called when user starts typing
    }
    
    func loadMorePhotos() {
        switch viewTheme {
        case .default:
            fetchDefaultPhotos()
        case .theme(let theme):
            fetchThemedPhotos(theme: theme)
        }
    }
    
}

// MARK: Private Methods
extension GalleryViewModel {
    
    private func fetchDefaultPhotos() {
        viewState = .loading(viewValues)

        apiManager.fetchDefaultPhotos { (images, canLoadMore) in
            self.viewValues.photosToShow = images
            self.viewState = .loaded(self.viewValues)
        }
    }

    
    private func fetchThemedPhotos(theme: String) {
        viewState = .loading(viewValues)

        apiManager.fetchThemedPhotos(theme: theme, completion: { (images, canLoadMore) in
            self.viewValues.photosToShow = images
            self.viewState = .loaded(self.viewValues)
        })
    }
    
    private func updateLatestSearchList(with theme: String) {
        // TODO: add list of recently looked for themes
    }
    
}


