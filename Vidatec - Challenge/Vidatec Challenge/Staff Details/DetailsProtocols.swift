//
//  DetailsViewProtocols.swift
//  Vidatec Challenge
//
//  Created by Charlie N on 02/08/2019.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation

protocol DetailsView: class {
    // For future use
}

typealias NetworkingDetailsView = DetailsView & NetworkingView

protocol DetailsViewPresenter {
    
    var client: Client? { get set }
    
    var viewTitle: String { get }
    
    var favouriteColor: String { get }
    
    init(view: NetworkingDetailsView, model: Person)

    func imageData(_ completion: @escaping (Data) -> Swift.Void)

    // Methods for TableView/CollectionView
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> PersonInfo?
}
