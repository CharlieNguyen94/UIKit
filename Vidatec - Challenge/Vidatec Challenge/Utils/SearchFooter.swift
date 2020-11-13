//
//  SearchFooter.swift
//  Vidatec Challenge
//
//  Created by Charlie N on 02/08/2019.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

class SearchFooter: UIView {
    
    //let label: UILabel = UILabel()
    @IBOutlet var label: UILabel!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    func configureView() {
        backgroundColor = UIColor.theme
        alpha = 0.0
    
    }

    
    //MARK: - Animation
    
    fileprivate func hideFooter() {
        UIView.animate(withDuration: 0.5) {[unowned self] in
            self.alpha = 0.0
        }
    }
    
    fileprivate func showFooter() {
        UIView.animate(withDuration: 0.5) {[unowned self] in
            self.alpha = 1.0
        }
    }
}

extension SearchFooter {
    //MARK: - Public API
    
    public func setNotFiltering() {
        label.text = nil
        hideFooter()
    }
    
    public func setIsFilteringToShow(filteredItemCount: Int, of totalItemCount: Int) {
        if (filteredItemCount == totalItemCount) {
            setNotFiltering()
        } else if (filteredItemCount == 0) {
            label.text = "No results match your search"
            showFooter()
        } else {
            label.text = "Showing \(filteredItemCount) of \(totalItemCount)"
            showFooter()
        }
    }
    
}

