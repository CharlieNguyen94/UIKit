//
//  GiphyNetworkManagerTestsTests.swift
//  GiphyAPI-InfiniteScrollTests
//
//  Created by Charlie on 19/06/19.
//  Copyright © 2019 Charlie. All rights reserved.
//

import XCTest
@testable import GiphyAPI_InfiniteScroll

struct NetworkSessionMock: NetworkSession {
    var data: Data?
    var error: Error?
    
    func loadData(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(data, error)
        return URLSessionDataTask()
    }
}

func getData(from fileName: String, ext: String = "json") -> Data? {
    guard let url = Bundle(for: GiphyNetworkManagerTests.self).url(forResource: fileName, withExtension: ext) else {
        assertionFailure("JSON file not found")
        return nil
    }
    guard let data = try? Data(contentsOf: url) else {
        assertionFailure("Conversion failure")
        return nil
    }
    return data
}

class GiphyNetworkManagerTests: XCTestCase {
    
    var sut: GiphyNetworkManager!
    
    override func tearDown() { sut = nil }
    
    func test_Search_API_Success() {
        // given
        guard let data = getData(from: "giphy_search_response_success") else {
            assertionFailure("Conversion failure")
            return
        }
        let mockSession = NetworkSessionMock(data: data, error: nil)
        sut = GiphyNetworkManager(with: mockSession)
        let exp = expectation(description: "Search API response")
        
        // when
        sut.search("hello") { response, error in
            
            // then
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            XCTAssertNotNil(response!.data)
            XCTAssertEqual(response!.data!.count, 25)
            exp.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func test_Search_API_Zero_Results() {
        // given
        guard let data = getData(from: "giphy_search_response_success_no_results") else {
            assertionFailure("Conversion failure")
            return
        }
        let mockSession = NetworkSessionMock(data: data, error: nil)
        sut = GiphyNetworkManager(with: mockSession)
        let exp = expectation(description: "Search API response")
        
        // when
        sut.search("hello") { response, error in
            
            // then
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            XCTAssertNotNil(response!.data)
            XCTAssertEqual(response!.data!.count, 0)
            exp.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}
