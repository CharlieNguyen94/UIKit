//
//  RoomPresenter.swift
//  Vidatec Challenge
//
//  Created by Charlie N on 03/08/2019.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation

class RoomPresenter: RoomViewPresenter {
    
    var client: Client?
    
    private weak var view: NetworkingRoomView?
    private var rooms: [Room]
    
    required init(view: NetworkingRoomView, model: [Room]) {
        self.view = view
        self.rooms = model
    }
    
    func fetchRooms() {
        
        view?.shouldBeLoading(true)
        
        let roomsRequest = VidatecRequest.rooms
        client?.getFeed(from: roomsRequest) { [unowned self] result in
            
            switch result {
                
            case .success(let data):
                
                do {
                    let results = try DataParser.parse(data, type: [Room].self)
                    self.rooms = results.sorted(by: { return $0.uuid < $1.uuid })
                    self.view?.updateTableView()
                } catch {
                    print(error)
                }
                
            case .failure(let error):
                print(error)
            }
            
            self.view?.shouldBeLoading(false)
            
        }
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        return rooms.count
    }
    
    func item(at indexPath: IndexPath) -> Room? {
        if indexPath.section >= numberOfSections() || indexPath.row < 0 || indexPath.row >= rooms.count { return nil }
        return rooms[indexPath.row]
    }
    
}
