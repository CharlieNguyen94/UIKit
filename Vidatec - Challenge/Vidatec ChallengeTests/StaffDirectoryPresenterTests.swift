//
//  StaffDirectoryPresenterTests.swift
//  Vidatec ChallengeTests
//
//  Created by Charlie N on 03/08/2019.
//  Copyright © 2019 Sample. All rights reserved.
//

import XCTest
@testable import Vidatec_Challenge

class MockStaffView: NetworkingStaffDirectoryView {
    
    var isFinishedLoading = false
    var isUpdatingTableview = false
    var filteredContent = (count: -1, max: -1)
    var shouldStopFiltering = false
    
    func shouldBeLoading(_ loading: Bool) {
        isFinishedLoading = !loading
    }
    
    func updateTableView() {
        isUpdatingTableview = true
    }
    
    func showFiltering(itemCount: Int, outOf maximum: Int) {
        filteredContent = (count: itemCount, max: maximum)
    }
    
    func stopFiltering() {
        shouldStopFiltering = true
    }
    
    
}

class MockStaffClient: Client {
    
    override func getFeed(from request: VidatecRequest, completion: @escaping (Result<Data, APIError>) -> Void) {
        
        let sampleDataPath = Bundle(for: type(of: self)).path(forResource: "MockStaffDirectoryResponse", ofType: "json")!
        let mockData = try! Data(contentsOf: URL(fileURLWithPath: sampleDataPath))
        
        return completion(.success(mockData))
    }
    
    override func fetchImageData(for person: Person, completion: @escaping (Result<Data, APIError>) -> Void) {
        
        guard let _ = URL(string: person.avatar) else {
            return completion(.failure(.invalidImageURL))
        }
        
        completion(.success(Data()))
        
    }
    
}

class StaffDirectoryPresenterTests: XCTestCase {

    var systemUnderTest: StaffDirectoryPresenter!
    var mockView: MockStaffView!
    var mockStaffClient: MockStaffClient!
    
    override func setUp() {
        mockView = MockStaffView()
        mockStaffClient = MockStaffClient()
        systemUnderTest = StaffDirectoryPresenter(view: mockView, model: [])
        systemUnderTest.client = mockStaffClient
    }

    override func tearDown() {
        mockView = nil
        systemUnderTest = nil
    }

    func testCreatedPresenter_EmptyState() {
        
        // Given an new presenter
        
        // When we check; the number of section and number of rows in the section
        let sections = systemUnderTest.numberOfSections(isFiltering: false)
        
        for section in 0...sections {
            let result = systemUnderTest.numberOfItems(in: section, isFiltering: false)
            XCTAssertEqual(result, 0)
        }
    }
    
    func testFetchData_FinishesLoading() {
        
        // Given
        systemUnderTest.fetchStaffDirectory()
        
        // When
        let result = mockView.isFinishedLoading
        
        // Then
        XCTAssertTrue(result)
    }
    
    func testFetchData_UpdatesView() {
        
        // Given
        systemUnderTest.fetchStaffDirectory()
        
        // When
        let result = mockView.isUpdatingTableview
        
        // Then
        XCTAssertTrue(result)
        
    }
    
    func testFetchData_HasStaffData() {
        
        // Given
        systemUnderTest.fetchStaffDirectory()
        
        //When
        let sections = systemUnderTest.numberOfSections(isFiltering: false)
        
        for section in 0...sections {
            
            // Then
            let result = systemUnderTest.numberOfItems(in: section, isFiltering: false)
            XCTAssertNotEqual(result, 0)
        }
        
    }

    func testFilteringName_ShowsFilterCount() {
        
        // When
        systemUnderTest.fetchStaffDirectory()
        
        // Given
        systemUnderTest.filterContent(with: "son", scope: SearchScopeTitle.name)
        _ = systemUnderTest.numberOfItems(in: 0, isFiltering: true)
        
        // Then
        XCTAssertEqual(mockView.filteredContent.count, 2)
        XCTAssertEqual(mockView.filteredContent.max, 24)
    
    }
    
    func testFilterName_DisplaySingleSection() {
        
        // When
        systemUnderTest.fetchStaffDirectory()
        
        // Given
        systemUnderTest.filterContent(with: "son", scope: SearchScopeTitle.name)
        let result = systemUnderTest.numberOfSections(isFiltering: true)
        
        // Then
        XCTAssertEqual(result, 1)
    }
    
    func testFilteringName_DisplayCorrectRow() {
        
        // When
        systemUnderTest.fetchStaffDirectory()
        
        // Given
        systemUnderTest.filterContent(with: "son", scope: SearchScopeTitle.name)
        let result = systemUnderTest.numberOfItems(in: 0, isFiltering: true)
        
        // Then
        XCTAssertEqual(result, 2)
        
    }
    
    func testFilteringJob_ShowsFilterCount() {
        
        // When
        systemUnderTest.fetchStaffDirectory()
        
        // Given
        systemUnderTest.filterContent(with: "son", scope: SearchScopeTitle.job)
        _ = systemUnderTest.numberOfItems(in: 0, isFiltering: true)
        
        // Then
        XCTAssertEqual(mockView.filteredContent.count, 1)
        XCTAssertEqual(mockView.filteredContent.max, 24)
    }
    
    func testFilterJob_DisplaySingleSection() {
        
        // When
        systemUnderTest.fetchStaffDirectory()
        
        // Given
        systemUnderTest.filterContent(with: "son", scope: SearchScopeTitle.job)
        let result = systemUnderTest.numberOfSections(isFiltering: true)
        
        // Then
        XCTAssertEqual(result, 1)
    }
    
    func testFilteringJob_DisplayCorrectRow() {
        
        // When
        systemUnderTest.fetchStaffDirectory()
        
        // Given
        systemUnderTest.filterContent(with: "son", scope: SearchScopeTitle.job)
        let result = systemUnderTest.numberOfItems(in: 0, isFiltering: true)
        
        // Then
        XCTAssertEqual(result, 1)
        
    }
    
    func testFiltering_StopsFiltering() {
        
        // Given
        systemUnderTest.fetchStaffDirectory()
        systemUnderTest.filterContent(with: "some")
        _ = systemUnderTest.numberOfItems(in: 0, isFiltering: true)
        
        // When
        _ = systemUnderTest.numberOfItems(in: 0, isFiltering: false)
        let result = mockView.shouldStopFiltering
        
        // Then
        XCTAssertTrue(result)
        
    }
    
    func testPresenter_GiveItem() {
        
        // Given
        systemUnderTest.fetchStaffDirectory()
        
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        let result = systemUnderTest.item(at: indexPath, isFiltering: false)
        
        // Then
        XCTAssertNotNil(result)
    }
    
    func testPresenter_InvalidSection_DoesNotGiveItem() {
        
        // Given
        systemUnderTest.fetchStaffDirectory()
        
        // When
        let section = systemUnderTest.numberOfSections(isFiltering: false)
        let indexPath = IndexPath(row: 0, section: section)
        let result = systemUnderTest.item(at: indexPath, isFiltering: false)
        
        // Then
        XCTAssertNil(result)
        
    }
    
    func testPresenter_InvalidRow_DoesNotGiveItem() {
        
        // Given
        systemUnderTest.fetchStaffDirectory()
        
        // When
        let row = systemUnderTest.numberOfItems(in: 0, isFiltering: false)
        let indexPath = IndexPath(row: row, section: 0)
        let result = systemUnderTest.item(at: indexPath, isFiltering: false)
        
        // Then
        XCTAssertNil(result)
        
    }
    
    func testPresenter_NegativeRow_DoesNotGiveItem() {
        
        // Given
        systemUnderTest.fetchStaffDirectory()
        
        // When
        let indexPath = IndexPath(row: -1, section: 0)
        let result = systemUnderTest.item(at: indexPath, isFiltering: false)
        
        // Then
        XCTAssertNil(result)
        
    }
    
    func testPresenter_ValidPerson_GivesImageData() {
        
        // Given
        let mockPerson = Person(uuid: "0", createdAt: Date(), avatar: "https://s3.amazonaws.com/uifaces/faces/twitter/johndezember/128.jpg", jobTitle: "", phone: "", favouriteColor: "", email: "", firstName: "", lastName: "")
        
        // When
        let promise = expectation(description: "Valid API Connection")
        var connectionResult: Data?
        systemUnderTest.imageData(for: mockPerson) { dataResult in
            connectionResult = dataResult
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 15, handler: nil)
        
        // Then
        XCTAssertNotNil(connectionResult)
    }
    
    func testPresenter_InvalidPerson_GivesNoImageData() {
        
        // Given
        let mockPerson = Person(uuid: "0", createdAt: Date(), avatar: "space image.png", jobTitle: "", phone: "", favouriteColor: "", email: "", firstName: "", lastName: "")
        
        // When
        let promise = expectation(description: "Valid API Connection")
        var connectionResult: Data?
        
        systemUnderTest.imageData(for: mockPerson) { dataResult in
            connectionResult = dataResult
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 15, handler: nil)
        
        // Then
        XCTAssertNil(connectionResult)
    }
}
