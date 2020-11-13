//
//  GIFImage.swift
//  GiphyAPI-InfiniteScroll
//
//  Created by Charlie on 20/06/19.
//  Copyright © 2019 Charlie. All rights reserved.
//

import Foundation

struct GIFImage: Decodable {
    enum TypeEnum: String, Decodable {
        case gif = "gif"
    }
    
    struct RemoteImageResource: Decodable {
        struct Resource: Decodable {
            var url: URL?
            var width: String?
            var height: String?
            var size: String? // in bytes
        }
        
        // Assumption - For now only preview and original is being decoded. In an ideal scenario,
        // we would decode every type of images and use the best image resolution suited for the current device,
        // which could range from iPhone SE to iPad Pro (or even a Mac now! Hail Project Catalyst 😍)
        var preview_gif: Resource?
        var original: Resource?
    }
    
    var type: TypeEnum?
    var id: String?
    var import_datetime: String?
    var title: String?
    var images: RemoteImageResource?
}
