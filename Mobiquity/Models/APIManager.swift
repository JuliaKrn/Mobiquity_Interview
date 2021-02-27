//
//  APIManager.swift
//  Mobiquity
//
//  Created by Iuliia Korniichuk on 26.02.2021.
//

import Foundation
import FlickrKit

protocol APIManagerProtocol {
    func fetchDefaultPhotos(completion: @escaping([UIImage]) -> Void)
    func fetchThemedPhotos(theme: String, completion: @escaping([UIImage], Bool) -> Void)
}

final class APIManager: APIManagerProtocol {
    
    enum Constants {
        static let apiKey = "04556db74aafe128ef601b9d64dcd045"
        static let secret = "3839bf3af2a37e74"
    }
    
    static let shared = APIManager()
    
    private var flickrManager: FlickrKit
    
    // TODO: move page to ViewModel?
    private var page = 0
    
    var images: [UIImage] = []
    
    private init() {
        flickrManager = FlickrKit.shared()
        flickrManager.initialize(withAPIKey: Constants.apiKey, sharedSecret: Constants.secret)
    }
    
    func fetchDefaultPhotos(completion: @escaping([UIImage]) -> Void) {
        
        fetchInterestingPhotosURLs { (urls) in
            let dispatchGroup = DispatchGroup()
            
            for url in urls {
                dispatchGroup.enter()
                
                self.fetchPhoto(from: url) { (image) in
                    self.images.append(image)
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main) {
                completion(self.images)
            }
        }
    }
    
    func fetchPhoto(from url: URL, completion: @escaping(UIImage) -> Void) {
        let urlRequest = URLRequest(url: url)
        
//        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
//        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: OperationQueue.main, completionHandler: { (response, data, error) -> Void in
            let image = UIImage(data: data!)
            completion(image!)
        })
    }
    
    
    func fetchInterestingPhotosURLs(completion: @escaping([URL]) -> Void) {
        let flickrInteresting = FKFlickrInterestingnessGetList()
        
        // TODO: store this info in manager not in vm
        flickrInteresting.per_page = "20"
        
        page += 1
        flickrInteresting.page = String(page)
        
        flickrManager.call(flickrInteresting) { [weak self] (response, error) -> Void in
            guard let self = self else {
                return
            }
            
            guard let response = response,
                  let photoArray = self.flickrManager.photoArray(fromResponse: response) else {
                completion([])
                return
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                let photoURLs = photoArray.compactMap {
                    self.flickrManager.photoURL(for: .largeSquare150, fromPhotoDictionary: $0)
                }
                completion(photoURLs)
            }
        }
    }
    
    // MARK: - Theme
    
    func fetchThemedPhotos(theme: String, completion: @escaping([UIImage], Bool) -> Void) {
        
    }
    
    func fetchPhotos(for theme: String, completion: @escaping([UIImage]) -> Void) {
        
        fetchThemePhotosURLs(theme: theme) { (urls) in
            guard let urls = urls else {
                return
            }

            for url in urls {
                self.fetchPhoto(from: url) { (image) in
                    self.images.append(image)
                    completion(self.images)
                }
            }
        }
        
    }
    
    
    func fetchThemePhotosURLs(theme: String, completion: @escaping([URL]?) -> Void) {
        
        flickrManager.call("flickr.photos.search",args: ["text": theme, "per_page": "2"], maxCacheAge: FKDUMaxAge.oneHour, completion: { [weak self] (response, error) -> Void in
            
            DispatchQueue.global(qos: .userInitiated).async {
                if let response = response, let photoArray = self?.flickrManager.photoArray(fromResponse: response) {
                    
                    let photoURLs = photoArray.compactMap {
                        self?.flickrManager.photoURL(for: .largeSquare150, fromPhotoDictionary: $0)
                    }
                    
                    completion(photoURLs)
                }
            }
        })
    }
}

extension APIManager {
    
}
