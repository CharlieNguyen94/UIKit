//
//  GiphyImageListCollectionViewAdapter.swift
//  GiphyAPI-InfiniteScroll
//
//  Created by Charlie on 21/06/19.
//  Copyright © 2019 Charlie. All rights reserved.
//

import UIKit
import SwiftyGif

protocol GiphyImageListCollectionViewAdapterDelegate {
    func loadNextPage()
}

class GiphyImageListCollectionViewAdapter: NSObject {
    let kSECTION_INSET: UIEdgeInsets
    let kNUMBER_OF_COLUMNS: Int
    let kMINIMUM_INTER_ITEM_SPACING: CGFloat
    let kMINIMUM_LINE_SPACING: CGFloat
    let kGIFImageCollectionViewCellName = "GIFImageCollectionViewCell"
    private(set) var collectionView: UICollectionView!
    private(set) var result: SearchAPIResult?
    private(set) var delegate: GiphyImageListCollectionViewAdapterDelegate?
    private(set) var prefetchingDownloadTasks = [IndexPath: URLSessionDataTask]()
    
    init(with collectionView: UICollectionView,
         and result: SearchAPIResult?,
         delegate: GiphyImageListCollectionViewAdapterDelegate?,
         sectionInset: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
         columns: Int = 2,
         minimumInteritemSpacing: CGFloat = CGFloat(8),
         minimumLineSpacing: CGFloat = CGFloat(8)) {
        
        kSECTION_INSET = sectionInset
        kNUMBER_OF_COLUMNS = columns
        kMINIMUM_INTER_ITEM_SPACING = minimumInteritemSpacing
        kMINIMUM_LINE_SPACING = minimumLineSpacing
        self.delegate = delegate
        self.result = result
        self.collectionView = collectionView
        
        super.init()
        
        setupCollectionViewTilesLayout()
        
        let nib = UINib(nibName: kGIFImageCollectionViewCellName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
    }
    
    func update(_ result: SearchAPIResult?) {
        self.result = result
        guard let layout = collectionView.collectionViewLayout as? TilesCollectionViewLayout else {
            return
        }
        layout.invalidateLayout()
        reloadData()
    }
    
    // Note - We could simply keep reloadData in view controller but it's more about separating concerns
    func reloadData() { collectionView.reloadData() }
    
    private func setupCollectionViewTilesLayout() {
        let flowLayout = TilesCollectionViewLayout(numberOfColumns: kNUMBER_OF_COLUMNS,
                                                   delegate: self,
                                                   sectionInset: kSECTION_INSET,
                                                   minimumInteritemSpacing: kMINIMUM_INTER_ITEM_SPACING,
                                                   minimumLineSpacing: kMINIMUM_LINE_SPACING)
        collectionView.collectionViewLayout = flowLayout
    }
}

extension GiphyImageListCollectionViewAdapter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? GIFImageCollectionViewCell else
        { return UICollectionViewCell() }
        
        if let image = result?.data?[indexPath.item] { cell.set(image) }
        return cell
    }
}

extension GiphyImageListCollectionViewAdapter: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let maxIndexPath = indexPaths.max(), let totalImagesCount = result?.data?.count else { return }
        if maxIndexPath.item >= totalImagesCount - 1 { delegate?.loadNextPage() }
        else { prefetchGIFs(for: indexPaths) }
    }
    
    func prefetchGIFs(for indexPaths: [IndexPath]) {
        // Pre-fetching the GIFs
        for indexPath in indexPaths {
            guard let url = result?.data?[indexPath.item].images?.preview_gif?.url else { continue }
            let downloadTask = UIImageView().setGifFromURL(url)
            prefetchingDownloadTasks[indexPath] = downloadTask
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        cancelPrefetch(for: indexPaths)
    }
    
    func cancelPrefetch(for indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            prefetchingDownloadTasks[indexPath]?.cancel()
            prefetchingDownloadTasks[indexPath] = nil
        }
    }
}

extension GiphyImageListCollectionViewAdapter: TilesCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        aspectRatioForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        guard let gif = result?.data?[indexPath.item].images?.preview_gif,
            let heightString = gif.height, let height = Double(heightString),
            let widthString = gif.width, let width = Double(widthString) else {
                return 0
        }
        return CGFloat(width/height)
    }
}
