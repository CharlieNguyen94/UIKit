//
//  RoomPresenterTests.swift
//  Vidatec ChallengeTests
//
//  Created by Charlie N on 03/08/2019.
//  Copyright © 2019 Sample. All rights reserved.
//

import XCTest
@testable import Vidatec_Challenge

class MockRoomView: NetworkingRoomView {

    var isUpdatingTableview = false
    var isFinishedLoading = false
    
    func shouldBeLoading(_ loading: Bool) {
        isFinishedLoading = !loading
    }
    
    func updateTableView() {
        isUpdatingTableview = true
    }
}

class MockRoomClient: Client {
    
    override func getFeed(from request: VidatecRequest, completion: @escaping (Result<Data, APIError>) -> Void) {
        
        let sampleDataPath = Bundle(for: type(of: self)).path(forResource: "MockRoomResponse", ofType: "json")!
        let mockData = try! Data(contentsOf: URL(fileURLWithPath: sampleDataPath))
        
        return completion(.success(mockData))
    }
    
}

class RoomPresenterTests: XCTestCase {
    
    var systemUnderTest: RoomViewPresenter!
    var mockClient: MockRoomClient!
    var mockView: MockRoomView!

    override func setUp() {
        
        mockClient = MockRoomClient()
        mockView = MockRoomView()
        systemUnderTest = RoomPresenter(view: mockView, model: [])
        systemUnderTest.client = mockClient
    }

    override func tearDown() {
        
        systemUnderTest = nil
        mockView = nil
        mockClient = nil
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testCreatedPresenter_EmptyState() {
        
        // Given an new presenter
        
        // When we check; the number of section and number of rows in the section
        let sections = systemUnderTest.numberOfSections()
        
        for section in 0..<sections {
            let result = systemUnderTest.numberOfItems(in: section)
            XCTAssertEqual(result, 0)
        }
    }
    
    func testFetchData_FinishesLoading() {
        
        // Given
        systemUnderTest.fetchRooms()
        
        // When
        let result = mockView.isFinishedLoading
        
        // Then
        XCTAssertTrue(result)
    }
    
    func testFetchData_UpdatesView() {
        
        // Given
        systemUnderTest.fetchRooms()
        
        // When
        let result = mockView.isUpdatingTableview
        
        // Then
        XCTAssertTrue(result)
        
    }
    
    func testPresenter_InvalidSection_DoesNotGiveItem() {
        
        // Given
        systemUnderTest.fetchRooms()
        
        // When
        let section = systemUnderTest.numberOfSections()
        let indexPath = IndexPath(row: 0, section: section)
        let result = systemUnderTest.item(at: indexPath)
        
        // Then
        XCTAssertNil(result)
        
    }
    
    func testPresenter_InvalidRow_DoesNotGiveItem() {
        
        // Given
        systemUnderTest.fetchRooms()
        
        // When
        let row = systemUnderTest.numberOfItems(in: 0)
        let indexPath = IndexPath(row: row, section: 0)
        let result = systemUnderTest.item(at: indexPath)
        
        // Then
        XCTAssertNil(result)
        
    }
    
    func testPresenter_NegativeRow_DoesNotGiveItem() {
        
        // Given
        systemUnderTest.fetchRooms()
        
        // When
        let indexPath = IndexPath(row: -1, section: 0)
        let result = systemUnderTest.item(at: indexPath)
        
        // Then
        XCTAssertNil(result)
        
    }
    
    func testPresenter_ValidIndexPath_GiveItem() {
        
        // Given
        systemUnderTest.fetchRooms()
        
        // When
        let result = systemUnderTest.item(at: IndexPath(row: 0, section: 0))
        
        // Then
        XCTAssertNotNil(result)
        
    }

}
