//
//  DetailsPresenter.swift
//  Vidatec Challenge
//
//  Created by Charlie N on 02/08/2019.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation

class DetailsPresenter: DetailsViewPresenter {
    
    var client: Client?
    
    private weak var view: NetworkingDetailsView?
    private var person: Person
    
    required init(view: NetworkingDetailsView, model: Person) {
        self.view = view
        self.person = model
    }
    
    var viewTitle: String {
        return person.fullName
    }
    
    var favouriteColor: String {
            return person.favouriteColor
    }
    
    func imageData(_ completion: @escaping (Data) -> Void) {
        
        view?.shouldBeLoading(true)
        
        client?.fetchImageData(for: person) { [unowned self] result in
            
            switch result {
            case .success(let imageData):
                completion(imageData)
            case .failure(let error):
                print("Error \(error)")
            }
            
            self.view?.shouldBeLoading(false)
            
        }
    }
    
    func numberOfSections() -> Int {
        return 2
    }
    
    func numberOfItems(in section: Int) -> Int {
        
        switch section {
        case 0: return 1
        case 1: return person.information.count
        default: return 0
        }
    }
    
    func item(at indexPath: IndexPath) -> PersonInfo? {
        
        switch indexPath.section {
        case 1:
            if indexPath.row < 0 || indexPath.row >= person.information.count { return nil }
            return person.information[indexPath.row]
        default: return nil
        }
        
    }
    
}
