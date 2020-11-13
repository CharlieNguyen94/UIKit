//
//  Client.swift
//  Vidatec Challenge
//
//  Created by Charlie N on 31/07/2019.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation
import UIKit.UIImage

// A list of possible errors, to be used with the ENUMs above
enum APIError: Error {
    
    case requestFailed
    case invalidData
    case invalidRequest
    case invalidImageURL
    case responseUnsuccessful
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .invalidRequest: return "Invalid Request"
        case .invalidImageURL: return "Invalid Image URL"
        case .responseUnsuccessful: return "Response Unsuccessful"
        }
    }
}

// A simpel protocol for a simple client
protocol APIClient {
    
    // A client uses a session
    var session: URLSession { get }
    
    // a client fetches data
    func fetch(with request: URLRequest, completion: @escaping (Result<Data, APIError>) -> Void)
    
}

// An extension to the client to simply fetch
extension APIClient {
    
    func fetch(with request: URLRequest, completion: @escaping (Result<Data, APIError>) -> Void) {
        
        let task = session.dataTask(with: request) { data, response, error in
            
            // Check for a HTTP Response Status Code
            guard let httpResponse = response as? HTTPURLResponse else { return completion(.failure(.requestFailed)) }
            
            
            switch httpResponse.statusCode {
            case 200...299:
                
                // Unwrap the data
                guard let data = data else { return completion(.failure(.invalidData)) }
                
                // Return the binary data
                return  completion(.success(data))
            default:
                return completion(.failure(.responseUnsuccessful))
            }
            
        }
        
        task.resume()
    }
}

// A concrete implementation of the client
class Client: APIClient {
    
    let session: URLSession
    var imageDataCache: NSCache<NSString, NSData>
    
    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
        self.imageDataCache = NSCache<NSString, NSData>()
    }
    
    func getFeed(from request: VidatecRequest, completion: @escaping (Result<Data, APIError>) -> Void) {
        
        guard let request = request.request else { return completion(.failure(.invalidRequest)) }
        
        fetch(with: request, completion: completion)
    }
    
    // Fetching Image + Caching
    func fetchImageData(for person: Person, completion: @escaping (Result<Data, APIError>) -> Void) {
        
        guard let imageUrl = URL(string: person.avatar) else { return completion(.failure(.invalidImageURL))  }
        
        let imageDataKey = imageUrl.path as NSString

        if let imageData = imageDataCache.object(forKey: imageDataKey) {
            return completion(.success(imageData as Data))
        }
        
        fetch(with: URLRequest(url: imageUrl)) { [unowned self] result in
            
            switch result {
            case .success(let data):
                self.imageDataCache.setObject(data as NSData, forKey: imageDataKey)
                return completion(.success(data))
            case .failure(_):
                return completion(.failure(.responseUnsuccessful))
            }
        }
        
    }
    
}

