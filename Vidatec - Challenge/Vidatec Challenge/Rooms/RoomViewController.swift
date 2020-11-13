//
//  RoomViewController.swift
//  Vidatec Challenge
//
//  Created by Charlie N on 03/08/2019.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController {

    var presenter: RoomViewPresenter!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        presenter.fetchRooms()
    }

}

extension RoomViewController: RoomView {
    func updateTableView() {
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
        }
    }
}

extension RoomViewController: NetworkingView {
    
    func shouldBeLoading(_ loading: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = loading
        }
    }
}

extension RoomViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension RoomViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTableViewCell", for: indexPath) as? RoomTableViewCell else { fatalError("Unable to dequeue") }
        
        guard let room = presenter.item(at: indexPath) else { return cell }
        
        cell.configure(using: room)
        
        return cell
        
    }
}

class RoomTableViewCell: UITableViewCell {
    
    func configure(using room: Room) {
        
        textLabel?.text = room.name.capitalized
        textLabel?.textColor = room.isOccupied ? UIColor.black : UIColor.white
        backgroundColor = room.isOccupied ? UIColor.lightGray : UIColor.theme
        
        layer.cornerRadius = frame.height / 2.0
        
    }
    
}
