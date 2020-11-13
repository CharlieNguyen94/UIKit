//
//  StaffDirectoryPresenter.swift
//  Vidatec Challenge
//
//  Created by Charlie N on 02/08/2019.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation

enum SearchScopeTitle {
    static let name = "Name"
    static let job = "Job Title"
}

class StaffDirectoryPresenter: StaffDirectoryViewPresenter {

    private weak var view: NetworkingStaffDirectoryView?
    private var people: [Person]
    private var filteredPeople: [Person]
    var client: Client?
    
    required init(view: NetworkingStaffDirectoryView, model: [Person]) {
        self.view = view
        self.people = model
        self.filteredPeople = []
    }
    
    func fetchStaffDirectory() {
        
        view?.shouldBeLoading(true)
        
        let peopleRequest = VidatecRequest.people
        client?.getFeed(from: peopleRequest) { [unowned self] result in
            
            switch result {
                
            case .success(let data):
                
                do {
                    let results = try DataParser.parse(data, type: [Person].self)
                    self.people = results.sorted(by: { return $0.lastName < $1.lastName })
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
    
    func filterContent(with searchText: String, scope: String = SearchScopeTitle.name) {
        
        filteredPeople = people.filter({
            
            switch scope {
            case SearchScopeTitle.name:
                return $0.reverseName.lowercased().contains(searchText.lowercased())
            case SearchScopeTitle.job:
                return $0.jobTitle.lowercased().contains(searchText.lowercased())
            default:
                return false //Should I really return false here?
            }
            
        })
        
        view?.updateTableView()
    }
    
    func imageData(for person: Person, completion: @escaping (Data?) -> Void) {
        
        client?.fetchImageData(for: person) { result in
            
            switch result {
            case .success(let imageData):
                completion(imageData)
            case .failure(let error):
                completion(nil)
                print("Error \(error)")
            }
            
        }
        
    }
    
    func numberOfSections(isFiltering: Bool) -> Int {
        return 1
    }
    
    func numberOfItems(in section: Int, isFiltering: Bool) -> Int {
        
        if isFiltering {
            view?.showFiltering(itemCount: filteredPeople.count, outOf: people.count)
            return filteredPeople.count
        }
        
        view?.stopFiltering()
        return people.count
        
    }
    
    func item(at indexPath: IndexPath, isFiltering: Bool) -> Person? {
        
        if indexPath.section > 0 { return nil }
        
        let dataSet = isFiltering ? filteredPeople : people
        
        if indexPath.row < 0 || indexPath.row >= dataSet.count { return nil }
        return dataSet[indexPath.row]
        
    }
    
}
