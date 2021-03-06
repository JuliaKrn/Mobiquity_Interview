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
    func getSearchList() -> [String]?
}

final class GalleryViewModel: GalleryViewModelProtocol {
    
    private enum ViewThemeType {
        case `default`
        case theme(String)
    }
    
    private enum Constants {
        static let photoSearchListKey = "PhotoSearchList"
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
    init(view: GalleryViewProtocol, apiManager: APIManagerProtocol) {
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
        updateSearchList(with: theme)
    }
    
    func loadMorePhotos() {
        switch viewTheme {
        case .default:
            fetchDefaultPhotos()
        case .theme(let theme):
            fetchThemedPhotos(theme: theme)
        }
    }
    
    func getSearchList() -> [String]? {
        UserDefaults.standard.stringArray(forKey: Constants.photoSearchListKey)
    }
    
}

// MARK: Private Methods
extension GalleryViewModel {
    
    private func fetchDefaultPhotos() {
        viewState = .loading(viewValues)

        apiManager.fetchDefaultPhotos { (images, succeess) in
            self.viewValues.photosToShow = images
            self.viewState = succeess ? .loaded(self.viewValues) : .error(self.viewValues)
        }
    }

    private func fetchThemedPhotos(theme: String) {
        viewState = .loading(viewValues)

        apiManager.fetchThemedPhotos(theme: theme, completion: { (images, succeess) in
            self.viewValues.photosToShow = images
            self.viewState = succeess ? .loaded(self.viewValues) : .error(self.viewValues)
        })
    }
    
    private func updateSearchList(with theme: String) {
        guard var searchList = UserDefaults.standard.stringArray(forKey: Constants.photoSearchListKey) else {
            UserDefaults.standard.setValue([theme], forKey: Constants.photoSearchListKey)
            return
        }
        
        if searchList.contains(theme) {
            return
        }
        
        searchList.append(theme)
        UserDefaults.standard.setValue(searchList, forKey: Constants.photoSearchListKey)
    }

}
