//
//  RequestResult.swift
//  Mobiquity
//
//  Created by Iuliia Korniichuk on 27.02.2021.
//

import Foundation

public struct RequestResult {
    
    public let data: Data
    public let response: HTTPURLResponse
    
    public init(data: Data, response: HTTPURLResponse) {
        self.data = data
        self.response = response
    }
    
}
