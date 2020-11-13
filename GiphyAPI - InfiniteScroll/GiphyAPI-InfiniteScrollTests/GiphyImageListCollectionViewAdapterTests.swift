//
//  GiphyImageListCollectionViewAdapterTests.swift
//  GiphyAPI-InfiniteScrollTests
//
//  Created by Charlie on 21/06/19.
//  Copyright © 2019 Charlie. All rights reserved.
//

import XCTest
@testable import GiphyAPI_InfiniteScroll

class GiphyImageListCollectionViewAdapterTests: XCTestCase {

    private class SearchViewControllerMock: UIViewController, GiphyImageListCollectionViewAdapterDelegate {
        var loadNextPageCalled = false
        func loadNextPage() { loadNextPageCalled = true }
    }
}

// MARK: Tests for data source functions
extension GiphyImageListCollectionViewAdapterTests {
    
    func getMockCollectionView() -> UICollectionView {
        return UICollectionView(frame: CGRect(x: 0, y: 0, width: 500, height: 500),
                                collectionViewLayout: getMockTilesCollectionViewLayout())
    }
    
    func getMockSectionInset() -> UIEdgeInsets { return UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4) }
    func getMockColumns() -> Int { return 2 }
    func getMockInteritemSpacing() -> CGFloat { return 5 }
    func getMockLineSpacing() -> CGFloat { return 6 }
    
    func getMockTilesCollectionViewLayout() -> TilesCollectionViewLayout {
        return TilesCollectionViewLayout(numberOfColumns: getMockColumns(), delegate: nil,
                                         sectionInset: getMockSectionInset(),
                                         minimumInteritemSpacing: getMockInteritemSpacing(),
                                         minimumLineSpacing: getMockLineSpacing())
    }
    
    func getMockSearchResult() -> SearchAPIResult {
        return try! JSONDecoder().decode(SearchAPIResult.self, from: getData(from: "giphy_search_response_success")!)
    }
    
    func test_Initialization() {
        // given
        let collectionView = getMockCollectionView()
        let searchResult = getMockSearchResult()
        let viewcontroller = SearchViewControllerMock()
        
        // when
        let sut = GiphyImageListCollectionViewAdapter(with: collectionView, and: searchResult, delegate: viewcontroller,
                                                      sectionInset: getMockSectionInset(), columns: getMockColumns(),
                                                      minimumInteritemSpacing: getMockInteritemSpacing(),
                                                      minimumLineSpacing: getMockLineSpacing())
        
        // then
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.collectionView, collectionView)
        
        XCTAssertNotNil(sut.collectionView.dataSource)
        assert(sut.collectionView.dataSource is GiphyImageListCollectionViewAdapter)
        
        XCTAssertNotNil(sut.collectionView.prefetchDataSource)
        assert(sut.collectionView.prefetchDataSource is GiphyImageListCollectionViewAdapter)
        
        XCTAssertEqual(sut.result!, searchResult)
        
        assert(sut.delegate! is SearchViewControllerMock)
        assert(sut.collectionView.collectionViewLayout is TilesCollectionViewLayout)
        
        let flowLayout = collectionView.collectionViewLayout as! TilesCollectionViewLayout
        XCTAssertEqual(flowLayout.sectionInset, UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4))
        XCTAssertEqual(flowLayout.minimumInteritemSpacing, 5)
        XCTAssertEqual(flowLayout.minimumLineSpacing, 6)
    }
    
    func test_CollectionView_NumberOfItems() {
        // given
        let collectionView = getMockCollectionView()
        let searchResult = getMockSearchResult()
        let viewcontroller = SearchViewControllerMock()
        
        // when
        let sut = GiphyImageListCollectionViewAdapter(with: collectionView, and: searchResult, delegate: viewcontroller)
        let numberOfItems = sut.collectionView(collectionView, numberOfItemsInSection: 0)
        
        // then
        XCTAssertEqual(numberOfItems, 25)
    }
    
    func test_CollectionView_CellForItemAtIndexPath() {
        // given
        let collectionView = getMockCollectionView()
        let searchResult = getMockSearchResult()
        let viewcontroller = SearchViewControllerMock()
        
        // when
        let sut = GiphyImageListCollectionViewAdapter(with: collectionView, and: searchResult, delegate: viewcontroller)
        let cell = sut.collectionView(collectionView, cellForItemAt: IndexPath(item: 0, section: 0))
        
        // then
        XCTAssertTrue(cell is GIFImageCollectionViewCell)
    }
    
    func test_CollectionViewCell_Size_AspectRatio() {
        // given
        let collectionView = getMockCollectionView()
        let searchResult = getMockSearchResult()
        let viewcontroller = SearchViewControllerMock()
        
        // when
        let sut = GiphyImageListCollectionViewAdapter(with: collectionView, and: searchResult, delegate: viewcontroller)
        let aspectRatio = sut.collectionView(collectionView, aspectRatioForImageAtIndexPath: IndexPath(item: 0, section: 0))
        let preview = searchResult.data!.first!.images!.preview_gif!
        let width = CGFloat(Double(preview.width!)!)
        let height = CGFloat(Double(preview.height!)!)
        
        // then
        XCTAssertEqual(aspectRatio, width/height)
    }
}

// MARK: Tests for data source prefetching
extension GiphyImageListCollectionViewAdapterTests {
    
    func test_CollectionView_PrefetchingNextImages() {
        // given
        let collectionView = getMockCollectionView()
        let searchResult = getMockSearchResult()
        let viewcontroller = SearchViewControllerMock()
        
        // when
        let sut = GiphyImageListCollectionViewAdapter(with: collectionView, and: searchResult, delegate: viewcontroller)
        let indexPath = IndexPath(item: 2, section: 0)
        let indexPath1 = IndexPath(item: 3, section: 0)
        sut.collectionView(collectionView, prefetchItemsAt: [indexPath, indexPath1])
        
        // then
        XCTAssertNotNil(sut.prefetchingDownloadTasks[indexPath])
        XCTAssertNotNil(sut.prefetchingDownloadTasks[indexPath1])
    }
    
    func test_CollectionView_PrefetchingNextImages_CancelOperation() {
        // given
        let collectionView = getMockCollectionView()
        let searchResult = getMockSearchResult()
        let viewcontroller = SearchViewControllerMock()
        
        // when
        let sut = GiphyImageListCollectionViewAdapter(with: collectionView, and: searchResult, delegate: viewcontroller)
        let indexPath = IndexPath(item: 2, section: 0)
        let indexPath1 = IndexPath(item: 3, section: 0)
        sut.collectionView(collectionView, prefetchItemsAt: [indexPath, indexPath1])
        sut.collectionView(collectionView, cancelPrefetchingForItemsAt: [indexPath1])
        
        // then
        XCTAssertNotNil(sut.prefetchingDownloadTasks[indexPath])
        XCTAssertNil(sut.prefetchingDownloadTasks[indexPath1])
    }
    
    func test_Prefetch_loadNextPage() {
        // given
        let collectionView = getMockCollectionView()
        let searchResult = getMockSearchResult()
        let viewcontroller = SearchViewControllerMock()
        
        // when
        let sut = GiphyImageListCollectionViewAdapter(with: collectionView, and: searchResult, delegate: viewcontroller)
        sut.collectionView(collectionView, prefetchItemsAt: [IndexPath(item: 24, section: 0)])
        
        // then
        XCTAssertTrue(viewcontroller.loadNextPageCalled)
    }
}
