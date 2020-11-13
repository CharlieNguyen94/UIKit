//
//  SearchViewController.swift
//  GiphyAPI-InfiniteScroll
//
//  Created by Charlie on 19/06/19.
//  Copyright © 2019 Charlie. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {

    @IBOutlet weak var resultsCollectionView: UICollectionView!
    
    private var manager = GiphyNetworkManager()
    private var currentSearchAPITask: URLSessionDataTask?
    private var result: SearchAPIResult?
    private var collectionViewAdapter: GiphyImageListCollectionViewAdapter?
    
    private var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search cool GIFs"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        resultsCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.becomeFirstResponder()
    }
    
    private func giphy_search(for string: String) {
        let newOffSet = (result?.pagination?.offset ?? 0) + (result?.pagination?.count ?? 0)
        currentSearchAPITask?.cancel()
        currentSearchAPITask = manager.search(string, newOffSet, completion: { (response, error) in
            DispatchQueue.main.async {
                if self.collectionViewAdapter == nil {
                    self.result = response
                    self.collectionViewAdapter = GiphyImageListCollectionViewAdapter(with: self.resultsCollectionView,
                                                                                     and: response, delegate: self)
                    self.collectionViewAdapter?.reloadData()
                } else if (response?.data?.count ?? 0) > 0 {
                    let existingImages = self.result?.data ?? []
                    self.result = response
                    self.result?.data?.insert(contentsOf: existingImages, at: 0)
                    self.collectionViewAdapter?.update(self.result)
                }
            }
        })
    }
    
    func filterContentForSearchText(_ searchText: String) {
        result = nil
        self.collectionViewAdapter?.update(result)
        giphy_search(for: searchText)
    }
}

extension SearchViewController: GiphyImageListCollectionViewAdapterDelegate {
    func loadNextPage() {
        giphy_search(for: searchController.searchBar.text ?? "")
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
}
