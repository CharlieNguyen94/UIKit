//
//  StaffDirectoryViewProtocols.swift
//  Vidatec Challenge
//
//  Created by Charlie N on 02/08/2019.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation

protocol StaffDirectoryView: class {
    func updateTableView()
    func showFiltering(itemCount: Int, outOf maximum: Int)
    func stopFiltering()
}

protocol NetworkingView: class {
    func shouldBeLoading(_ loading: Bool)
}

typealias NetworkingStaffDirectoryView = StaffDirectoryView & NetworkingView

protocol StaffDirectoryViewPresenter {
    
    var client: Client? { get set }
    
    init(view: NetworkingStaffDirectoryView, model: [Person])
    
    func fetchStaffDirectory()
    func imageData(for person: Person, completion: @escaping (Data?) -> Swift.Void)
    
    func filterContent(with searchText: String, scope: String)
    
    // Methods for TableView/CollectionView
    func numberOfSections(isFiltering: Bool) -> Int
    func numberOfItems(in section: Int, isFiltering: Bool) -> Int
    func item(at indexPath: IndexPath, isFiltering: Bool) -> Person?
}
