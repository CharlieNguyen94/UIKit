//
//  GiphyNetworkURLBuilderTests.swift
//  GiphyAPI-InfiniteScrollTests
//
//  Created by Charlie on 21/06/19.
//  Copyright © 2019 Charlie. All rights reserved.
//

import XCTest
@testable import GiphyAPI_InfiniteScroll

class GiphyNetworkURLBuilderTests: XCTestCase {
    
    let sut = GiphyNetworkURLBuilder()
    
    func test_API_WithoutParamters() {
        // given
        let expected = URL(string: "https://api.giphy.com/v1/gifs/search?api_key=S6E6B58AkpGPnYkQ4IHAVgr0heeae5ju")
        
        // when
        let result = sut.build(for: .search)
        
        // then
        XCTAssertEqual(result, expected)
    }
    
    func test_API_WithParameters() {
        // given
        let parameters: [String : Any] = [ "q": "hello" ]
        let expected = URL(string: "https://api.giphy.com/v1/gifs/search?api_key=S6E6B58AkpGPnYkQ4IHAVgr0heeae5ju&q=hello")
        
        // when
        let result = sut.build(for: .search, with: parameters)
        
        // then
        XCTAssertEqual(result, expected)
    }
}
