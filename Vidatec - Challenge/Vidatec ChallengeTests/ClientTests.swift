//
//  ClientTests.swift
//  Vidatec ChallengeTests
//
//  Created by Charlie N on 31/07/2019.
//  Copyright © 2019 Sample. All rights reserved.
//

import XCTest
@testable import Vidatec_Challenge

class ClientTests: XCTestCase {

    let defaultTimeout = 15.0
    var systemUnderTest: Client!
    
    override func setUp() {
        systemUnderTest = Client()
    }
    
    override func tearDown() {
        systemUnderTest = nil
    }
    
    func testValidAPIConnection() {
        
        let request = VidatecRequest.rooms
        let promise = expectation(description: "Valid API Connection")
        
        systemUnderTest.getFeed(from: request) { result in
            promise.fulfill()
        }
        
        waitForExpectations(timeout: defaultTimeout, handler: nil)
    }
    
    func testReceivedDataFromServer() {
        
        let request = VidatecRequest.rooms
        let promise = expectation(description: "Valid API Connection")
        var connectionResult: Result<Data, APIError>?
        
        systemUnderTest.getFeed(from: request){ result in
            connectionResult = result
            promise.fulfill()
        }
        
        waitForExpectations(timeout: defaultTimeout, handler: nil)
        
        guard let actualResult = connectionResult else { return XCTFail() }
        
        switch actualResult {
        case .success(_): break
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

}
