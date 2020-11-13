//
//  DetailsPresenterTests.swift
//  Vidatec ChallengeTests
//
//  Created by Charlie N on 03/08/2019.
//  Copyright © 2019 Sample. All rights reserved.
//

import XCTest
@testable import Vidatec_Challenge

class MockDetailsView: NetworkingDetailsView {
    
    var isFinishedLoading = false
    
    func shouldBeLoading(_ loading: Bool) {
        isFinishedLoading = !loading
    }
}

class DetailsPresenterTests: XCTestCase {

    var systemUnderTest: DetailsPresenter!
    var mockDetailsView: NetworkingDetailsView!
    var mockClient: MockStaffClient!
    
    let mockPerson = Person(uuid: "1",
                            createdAt: Date(),
                            avatar: "https://s3.amazonaws.com/uifaces/faces/twitter/johndezember/128.jpg",
                            jobTitle: "Dynamic Implementation Designer",
                            phone: "556.662.4422 x3344",
                            favouriteColor: "#023a77",
                            email: "Benny78@gmail.com",
                            firstName: "Jan",
                            lastName: "Thompson")
    
    override func setUp() {
        
        mockClient = MockStaffClient()
        mockDetailsView = MockDetailsView()
        systemUnderTest = DetailsPresenter(view: mockDetailsView, model: mockPerson)
        systemUnderTest.client = mockClient
    }

    override func tearDown() {
        
        mockClient = nil
        mockDetailsView = nil
        systemUnderTest = nil
    }

    func testPresenter_GivesTitle() {
        
        // Given
        
        // When
        let result = systemUnderTest.viewTitle.isEmpty
        
        // Then
        XCTAssertFalse(result)
        
    }
    
    func testPresenter_GivesFavouriteColour() {
        
        // Given
        
        // When
        let result = systemUnderTest.favouriteColor.isEmpty
        
        // Then
        XCTAssertFalse(result)
        
    }
    
    func testPresenter_GivesImageData() {
        
        // Given
        
        // When
        let promise = expectation(description: "Valid API Connection")
        var connectionResult: Data?
        
        systemUnderTest.imageData { dataResult in
            connectionResult = dataResult
            promise.fulfill()
        }
                
        waitForExpectations(timeout: 15, handler: nil)
        
        // Then
        XCTAssertNotNil(connectionResult)
    }
    
    func testPresenter_GiveValidSectionCount() {
        
        // Given
        
        // When
        let result = systemUnderTest.numberOfSections()
        
        // Then
        XCTAssertEqual(result, 2)
    }
    
    func testPresenter_GiveValidRowCount() {
        
        let sections = systemUnderTest.numberOfSections()
        
        for section in 0...sections {
            
            let result = systemUnderTest.numberOfItems(in: section)
            
            switch section {
            case 0: XCTAssertEqual(result, 1)
            case 1: XCTAssertEqual(result, 3)
            default: XCTAssertEqual(result, 0)
            }
            
        }
        
    }
    
    func testPresenter_InvalidSection_DoesNotGiveItem() {

        // Given

        // When
        let section = systemUnderTest.numberOfSections()
        let indexPath = IndexPath(row: 0, section: section)
        let result = systemUnderTest.item(at: indexPath)

        // Then
        XCTAssertNil(result)

    }

    func testPresenter_InvalidRow_DoesNotGiveItem() {

        // Given

        // When
        let row = systemUnderTest.numberOfItems(in: 1)
        let indexPath = IndexPath(row: row, section: 1)
        let result = systemUnderTest.item(at: indexPath)

        // Then
        XCTAssertNil(result)

    }

    func testPresenter_NegativeRow_DoesNotGiveItem() {

        // Given

        // When
        let indexPath = IndexPath(row: -1, section: 1)
        let result = systemUnderTest.item(at: indexPath)

        // Then
        XCTAssertNil(result)

    }
    
    func testPresenter_ValidIndexPath_GiveItem() {
        
        // Given
        
        // When
        let result = systemUnderTest.item(at: IndexPath(row: 0, section: 1))
        
        // Then
        XCTAssertNotNil(result)
        
    }
    
}
