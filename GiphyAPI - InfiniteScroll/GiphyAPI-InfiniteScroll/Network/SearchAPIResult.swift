//
//  SearchAPIResult.swift
//  GiphyAPI-InfiniteScroll
//
//  Created by Charlie on 21/06/19.
//  Copyright © 2019 Charlie. All rights reserved.
//

import Foundation

struct SearchAPIResult: Decodable {
    struct Pagination: Decodable {
        var total_count: Int? // Assumption - The total count is less than 2^64
        var count: Int?
        var offset: Int?
    }
    
    struct Meta: Decodable {
        var status: Int?
        var msg: String?
    }
    
    var data: [GIFImage]?
    var pagination: Pagination?
    var meta: Meta?
    var response_id: String?
}

extension SearchAPIResult: Equatable {
    static func == (lhs: SearchAPIResult, rhs: SearchAPIResult) -> Bool { return lhs.response_id == rhs.response_id }
}
