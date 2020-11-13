//
//  GIFImageCollectionViewCell.swift
//  GiphyAPI-InfiniteScroll
//
//  Created by Charlie on 21/06/19.
//  Copyright © 2019 Charlie. All rights reserved.
//

import UIKit
import SwiftyGif

final class GIFImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    private var downloadTask: URLSessionDataTask?
    
    func set(_ image: GIFImage) {
        //clearing existing GIF to avoid GIF images overlapping each other when user is scrolling
        downloadTask?.cancel()
        imageView.image = nil
        imageView.gifImage?.clear()
        imageView.gifImage = nil
        imageView.currentImage = nil
        
        // Loading the GIF
        guard let url = image.images?.preview_gif?.url else { return }
        downloadTask = imageView.setGifFromURL(url)
    }
}
