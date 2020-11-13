//
//  TilesCollectionViewLayout.swift
//  GiphyAPI-InfiniteScroll
//
//  Created by Charlie on 21/06/19.
//  Copyright © 2019 Charlie. All rights reserved.
//

import UIKit

protocol TilesCollectionViewLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, aspectRatioForImageAtIndexPath indexPath: IndexPath) -> CGFloat
}

class TilesCollectionViewLayout: UICollectionViewFlowLayout {
    
    weak var delegate: TilesCollectionViewLayoutDelegate!
    private(set) var cache = [UICollectionViewLayoutAttributes]()
    private var numberOfColumns: Int
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    private var contentHeight = CGFloat(0)
    override var collectionViewContentSize: CGSize { return CGSize(width: contentWidth, height: contentHeight) }
    
    init(numberOfColumns: Int = 2,
         delegate: TilesCollectionViewLayoutDelegate?,
         sectionInset: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
         minimumInteritemSpacing: CGFloat = CGFloat(8),
         minimumLineSpacing: CGFloat = CGFloat(8)) {
        
        self.numberOfColumns = numberOfColumns
        self.delegate = delegate
        super.init()
        self.sectionInset = sectionInset
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("Not implemented") }
    
    func getColumnWidth() -> CGFloat {
        let interItemSpacing = (minimumInteritemSpacing * CGFloat(numberOfColumns - 1))
        let sectionInsets = sectionInset.left + sectionInset.right
        let columnWidth = (contentWidth - sectionInsets - interItemSpacing) / CGFloat(numberOfColumns)
        return columnWidth
    }
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else { return }
        
        let columnWidth = getColumnWidth()
        
        var xOffset = [CGFloat]()
        for column in 0..<numberOfColumns {
            var x: CGFloat = 0
            if let previous = xOffset.last { x = previous + columnWidth + minimumInteritemSpacing }
            else { x = CGFloat(column) * columnWidth + sectionInset.left }
            xOffset.append(x)
        }

        var column = 0
        let firstRowOffset = collectionView.contentInset.top + sectionInset.top
        var yOffset = [CGFloat](repeating: firstRowOffset, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            guard let attributes = calculateFrames(for: item,
                                                   column: &column,
                                                   maximumWidth: columnWidth,
                                                   yOffset: &yOffset,
                                                   columnX: xOffset[column]) else { continue }
            cache.append(attributes)
        }
    }
    
    func calculateFrames(for itemIndex: Int,
                         column: inout Int,
                         maximumWidth: CGFloat,
                         yOffset: inout [CGFloat],
                         columnX: CGFloat) -> UICollectionViewLayoutAttributes? {
        
        guard let collectionView = collectionView else { return nil }
        
        let indexPath = IndexPath(item: itemIndex, section: 0)
        
        // Requesting aspect ratio of the image from the delegate and calculating new frame
        let aspectRatio = delegate.collectionView(collectionView, aspectRatioForImageAtIndexPath: indexPath)
        let height = (maximumWidth / aspectRatio)
        let frame = CGRect(x: columnX, y: yOffset[column], width: maximumWidth, height: height)
        
        contentHeight = max(contentHeight, frame.maxY)
        yOffset[column] += (height + minimumLineSpacing)
        
        // Set column to 0 only if it has reached to the right most one else advance to the next column
        column = (column < (numberOfColumns - 1)) ? (column + 1) : 0
        
        // Adding calculated frame to cache
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = frame
        return attributes
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        cache = []
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesForElementsInVisibleRect = [UICollectionViewLayoutAttributes]()
        for attributesForElement in cache {
            guard attributesForElement.frame.intersects(rect) else { continue }
            attributesForElementsInVisibleRect.append(attributesForElement)
        }
        return attributesForElementsInVisibleRect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
