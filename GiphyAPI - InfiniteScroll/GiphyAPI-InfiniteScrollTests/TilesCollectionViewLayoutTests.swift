//
//  TilesCollectionViewLayoutTests.swift
//  GiphyAPI-InfiniteScrollTests
//
//  Created by Charlie on 21/06/19.
//  Copyright © 2019 Charlie. All rights reserved.
//

import XCTest
@testable import GiphyAPI_InfiniteScroll

class TilesCollectionViewLayoutTests: XCTestCase {

    // Assumption - The collectionview layout supports 2 columns layout only.
    
    class TilesCollectionViewLayoutDelegateMock: TilesCollectionViewLayoutDelegate {
        func collectionView(_ collectionView: UICollectionView,
                            aspectRatioForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
            return [1.1, 1.2, 0.78, 0.3, 4][indexPath.item]
        }
    }
    
    class CollectionViewDatasourceMock: NSObject, UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return 5 }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        { return UICollectionViewCell() }
    }
    
    var dataSource: CollectionViewDatasourceMock?
    
    func getMockCollectionView() -> UICollectionView {
        return UICollectionView(frame: CGRect(x: 0, y: 0, width: 500, height: 500),
                                collectionViewLayout: getMockTilesCollectionViewLayout())
    }
    
    func getMockTilesCollectionViewLayout() -> TilesCollectionViewLayout {
        return TilesCollectionViewLayout(numberOfColumns: getMockColumns(), delegate: nil,
                                         sectionInset: getMockSectionInset(),
                                         minimumInteritemSpacing: getMockInteritemSpacing(),
                                         minimumLineSpacing: getMockLineSpacing())
    }
    
    func getMockSectionInset() -> UIEdgeInsets { return UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4) }
    func getMockColumns() -> Int { return 2 }
    func getMockInteritemSpacing() -> CGFloat { return 5 }
    func getMockLineSpacing() -> CGFloat { return 6 }
    
    func getMockSearchResult() -> SearchAPIResult {
        return try! JSONDecoder().decode(SearchAPIResult.self, from: getData(from: "giphy_search_response_success")!)
    }
    
    func test_FirstLoad_Cache() {
        // given
        let collectionView = getMockCollectionView()
        dataSource = CollectionViewDatasourceMock()
        collectionView.dataSource = dataSource
        
        let sut = collectionView.collectionViewLayout as! TilesCollectionViewLayout
        let delegate = TilesCollectionViewLayoutDelegateMock()
        sut.delegate = delegate
        
        // when
        sut.prepare()
        
        // then
        XCTAssertEqual(sut.cache[0].bounds.size, CGSize(width: 244.5, height: 222.27272727272725))
    }
}
