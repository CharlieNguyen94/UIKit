//
//  RoomProtocols.swift
//  Vidatec Challenge
//
//  Created by Charlie N on 03/08/2019.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation

protocol RoomView: class {
    func updateTableView()
}

typealias NetworkingRoomView = RoomView & NetworkingView

protocol RoomViewPresenter: class {
    
    var client: Client? { get set }
    
    init(view: NetworkingRoomView, model: [Room])
    
    func fetchRooms()
    
    // Methods for TableView/CollectionView
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> Room?
    
}
