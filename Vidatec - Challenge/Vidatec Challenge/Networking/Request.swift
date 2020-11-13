//
//  Request.swift
//  Vidatec Challenge
//
//  Created by Charlie N on 31/07/2019.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation

// Base definition of a 'Request'
protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var queries: [URLQueryItem] { get }
}
extension Endpoint {
    
    // used to create a URL
    var urlComponents: URLComponents? {
        
        guard var components = URLComponents(string: base)  else { return nil }
        components.path = path
        components.queryItems = queries
        return components
    }
    
    // Used to create URLReqest
    var request: URLRequest? {
        guard let url = urlComponents?.url else { return nil }
        return URLRequest(url: url)
    }
}

enum VidatecRequest {
    case people
    case rooms
}

extension VidatecRequest: Endpoint {
    
    var base: String {
        return "https://5cc736f4ae1431001472e333.mockapi.io"
    }
    
    var queries: [URLQueryItem] {
        return []
    }
    
    var path: String {
        switch self {
        case .people: return "/people"
        case .rooms: return "/rooms"
        }
    }
    
}
