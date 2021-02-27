//
//  APIManager.swift
//  Mobiquity
//
//  Created by Iuliia Korniichuk on 26.02.2021.
//

import Foundation
import FlickrKit

protocol APIManagerProtocol {
    func fetchDefaultPhotos(completion: @escaping([UIImage], Bool) -> Void)
    func fetchThemedPhotos(theme: String, completion: @escaping([UIImage], Bool) -> Void)
    
    func reset()
}

final class APIManager: APIManagerProtocol {
    
    static let shared = APIManager()
    
    private enum Constants {
        static let apiKey = "04556db74aafe128ef601b9d64dcd045"
        static let secret = "3839bf3af2a37e74"
        static let photosPerPage = "20"
    }
        
    private let flickrManager: FlickrKit
    private let sessionManager: SessionManager
    
    // TODO: move page to ViewModel?
    private var page = 0
    
    var images: [UIImage] = []
    
    private init() {
        flickrManager = FlickrKit.shared()
        flickrManager.initialize(withAPIKey: Constants.apiKey, sharedSecret: Constants.secret)
        
        sessionManager = SessionManager()
    }
    
    // TODO: bool can be used for is it last page or not
    func fetchDefaultPhotos(completion: @escaping([UIImage], Bool) -> Void) {
        
        fetchInterestingPhotosURLs { [weak self] (urls, success) in
            guard let self = self else {
                return
            }
            
            guard !urls.isEmpty else {
                completion([], false)
                return
            }
            
            let dispatchGroup = DispatchGroup()
            
            for url in urls {
                dispatchGroup.enter()
                
                self.fetchPhoto(from: url) { (image) in
                    if let image = image {
                        self.images.append(image)
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main) {
                completion(self.images, true)
            }
        }
    }
    
    func reset() {
        images = []
        page = 0
    }
    
    private func fetchPhoto(from url: URL, completion: @escaping(UIImage?) -> Void) {
        let urlRequest = URLRequest(url: url)
        
        sessionManager.performRequest(request: urlRequest) { (result, error) in
            guard let data = result?.data, error == nil else {
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }
    }
    
    // TODO: prevent from loading the last page
    private func isTheLastPage() -> Bool {
        return false
    }

}

// MARK: - Interestingness Photos
extension APIManager {
    
    private func fetchInterestingPhotosURLs(completion: @escaping([URL], Bool) -> Void) {
        let flickrInteresting = FKFlickrInterestingnessGetList()
        
        page += 1
        flickrInteresting.page = String(page)
        flickrInteresting.per_page = Constants.photosPerPage
        
        flickrManager.call(flickrInteresting) { [weak self] (response, error) -> Void in
            guard let self = self else {
                return
            }
            
            guard let response = response,
                  let photoArray = self.flickrManager.photoArray(fromResponse: response) else {
                completion([], false)
                return
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                let photoURLs = photoArray.compactMap {
                    self.flickrManager.photoURL(for: .largeSquare150, fromPhotoDictionary: $0)
                }
                completion(photoURLs, true)
            }
        }
    }
    
}

// MARK: - Theme Photos
extension APIManager {
    
    func fetchThemedPhotos(theme: String, completion: @escaping([UIImage], Bool) -> Void) {
        
        fetchThemePhotosURLs(theme: theme) { [weak self] (urls, success) in
            guard let self = self else {
                return
            }
            
            guard !urls.isEmpty else {
                completion([], false)
                return
            }
            
            let dispatchGroup = DispatchGroup()
            
            for url in urls {
                dispatchGroup.enter()
                
                self.fetchPhoto(from: url) { (image) in
                    if let image = image {
                        self.images.append(image)
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main) {
                completion(self.images, true)
            }
        }
        
    }
    
    
    func fetchThemePhotosURLs(theme: String, completion: @escaping([URL], Bool) -> Void) {
        page += 1
        let args = ["text": theme,
                    "per_page": Constants.photosPerPage,
                    "page": String(page)]
        
        flickrManager.call("flickr.photos.search",args: args, maxCacheAge: FKDUMaxAge.oneDay, completion: { [weak self] (response, error) -> Void in
            guard let self = self else {
                return
            }
            
            guard let response = response,
                  let photoArray = self.flickrManager.photoArray(fromResponse: response) else {
                completion([], false)
                return
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                let photoURLs = photoArray.compactMap {
                    self.flickrManager.photoURL(for: .largeSquare150, fromPhotoDictionary: $0)
                }
                completion(photoURLs, true)
            }
        })
    }
    
    
}
