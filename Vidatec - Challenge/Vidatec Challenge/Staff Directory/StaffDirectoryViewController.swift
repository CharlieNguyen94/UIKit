//
//  StaffDirectoryViewController.swift
//  Vidatec Challenge
//
//  Created by Charlie N on 31/07/2019.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

class StaffDirectoryViewController: UIViewController {
    
    // TODO: Follow MVP
    var presenter: StaffDirectoryViewPresenter!

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchFooter: SearchFooter!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()

        presenter.fetchStaffDirectory()
    }
    
    func setupUI () {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = searchFooter
        
        tableView.estimatedRowHeight = 50 // some constant value
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.separatorColor = .theme
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Staff"
        searchController.searchBar.scopeButtonTitles = [SearchScopeTitle.name, SearchScopeTitle.job]
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: - Private instance methods
    
    var searchBarIsEmpty: Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "showDetails":
            guard let destination = segue.destination as? DetailsViewController,
            let selectedPerson = sender as? Person else { return }
            
            let detailsPresetner = DetailsPresenter(view: destination, model: selectedPerson)
            detailsPresetner.client = presenter.client
            
            destination.presenter = detailsPresetner
        default:
            print("Error")
        }
        
    }

}

// MARK: - StaffDirectoryView
extension StaffDirectoryViewController: StaffDirectoryView {
    
    func updateTableView() {
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
        }
    }
    
    func showFiltering(itemCount: Int, outOf maximum: Int) {
        searchFooter.setIsFilteringToShow(filteredItemCount: itemCount, of: maximum)
    }
    
    func stopFiltering() {
        searchFooter.setNotFiltering()
    }

}

// MARK: - NetworkingView
extension StaffDirectoryViewController: NetworkingView {
    func shouldBeLoading(_ loading: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = loading
        }
    }
}

// MARK: - UITableViewDelegate
extension StaffDirectoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections(isFiltering: isFiltering)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems(in: section, isFiltering: isFiltering)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? StaffDirectoryTableViewCell,
        let currentPerson = presenter.item(at: indexPath, isFiltering: isFiltering) else { fatalError("Unable to deque cell") }
        
        cell.fullNameLabel.text = currentPerson.reverseName
        cell.jobLabel.text = currentPerson.jobTitle
        
        presenter.imageData(for: currentPerson) { data in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                cell.avatarImageView.image = image
            }
        }
        
        return cell
        
    }
}

// MARK: - UITableViewDelegate
extension StaffDirectoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let currentPerson = presenter.item(at: indexPath, isFiltering: isFiltering) else { return print("Nothing selected") }
        performSegue(withIdentifier: "showDetails", sender: currentPerson)
    }
    
}

// MARK: - UISearchResultsUpdating
extension StaffDirectoryViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        guard let searchText = searchBar.text,
            let scope = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex] else { return print("No text entered") }
        presenter.filterContent(with: searchText, scope: scope)
    }
}

// MARK: - UISearchBarDelegate
extension StaffDirectoryViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        guard let searchText = searchBar.text, let scopeTitles = searchBar.scopeButtonTitles else { return }
        presenter.filterContent(with: searchText, scope: scopeTitles[selectedScope])
    }
    
}

