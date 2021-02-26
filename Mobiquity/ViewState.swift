//
//  ViewState.swift
//  Mobiquity
//
//  Created by Iuliia Korniichuk on 25.02.2021.
//

import Foundation

enum ViewState<T> {
    
    case loading(T)
    case loaded(T)
    case error(T)
    
    mutating func toLoading(values: T) {
        switch self {
        case .loading:
            break
        case .loaded, .error:
            self = .loading(values)
        }
    }
    
    mutating func toLoaded(values: T) {
        switch self {
        case .loaded:
            break
        case .loading, .error:
            self = .loading(values)
        }
    }
    
    mutating func toError(values: T) {
        self = .error(values)
    }
    
}
