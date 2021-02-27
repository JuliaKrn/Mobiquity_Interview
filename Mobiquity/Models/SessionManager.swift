//
//  SessionManager.swift
//  Mobiquity
//
//  Created by Iuliia Korniichuk on 27.02.2021.
//

import Foundation

final class SessionManager {
    
    private let sessionConfiguration: URLSessionConfiguration
    private let session: URLSession
    
    init(urlSessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default) {
        sessionConfiguration = urlSessionConfiguration
        sessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad
        session = URLSession(configuration: urlSessionConfiguration)
    }
    
    func performRequest(request: URLRequest, completion: @escaping (RequestResult?, Error?) -> Void) {
        
        let task: URLSessionDataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in

            guard error == nil,
                  let data = data,
                  let response = response as? HTTPURLResponse else {
                completion(nil, error)
                return
            }
            
            let networkResult = RequestResult(data: data, response: response)
            completion(networkResult, nil)
        })
        
        task.resume()
    }
    
}
