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
    
    private enum Constants {
        static let photosPerPage = "20"
    }
    
    private let flickrManager: FlickrKit
    private let sessionManager: SessionManager
    
    private var page = 0
    private var maxPageNumber: Int?
    private var images: [UIImage] = []
    
    init(flickrManager: FlickrKit) {
        self.flickrManager = flickrManager
        sessionManager = SessionManager()
    }
    
    func fetchDefaultPhotos(completion: @escaping([UIImage], Bool) -> Void) {
        
        fetchInterestingPhotosURLs { [weak self] (urls, success) in
            guard let self = self else {
                return
            }
            
            self.fetchPhotos(from: urls) { (photos, success) in
                completion(photos, success)
            }
        }
    }
    
    func fetchThemedPhotos(theme: String, completion: @escaping([UIImage], Bool) -> Void) {
        
        fetchThemePhotosURLs(theme: theme) { [weak self] (urls, success) in
            guard let self = self else {
                return
            }
            
            self.fetchPhotos(from: urls) { (photos, success) in
                completion(photos, success)
            }
        }
    }
    
    func reset() {
        images = []
        page = 0
        maxPageNumber = nil
    }
    
}

// MARK: - Private
extension APIManager {
    
    private func fetchPhotos(from urls: [URL], completion: @escaping([UIImage], Bool) -> Void) {
        
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
    
}

// MARK: - Interestingness Photos
extension APIManager {
    
    private func fetchInterestingPhotosURLs(completion: @escaping([URL], Bool) -> Void) {
        page += 1
        
        if let maxPageNumber = maxPageNumber, page > maxPageNumber {
            completion([], true)
            return
        }
        
        let flickrInteresting = FKFlickrInterestingnessGetList()
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
            
            if let photos = response["photos"] as? [String: Any],
               let totalPages = photos["pages"] as? Int {
                self.maxPageNumber = totalPages
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
    
    func fetchThemePhotosURLs(theme: String, completion: @escaping([URL], Bool) -> Void) {
        page += 1
        
        if let maxPageNumber = maxPageNumber, page > maxPageNumber {
            completion([], true)
            return
        }
        
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
            
            if let photos = response["photos"] as? [String: Any],
               let totalPages = photos["pages"] as? Int {
                self.maxPageNumber = totalPages
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
