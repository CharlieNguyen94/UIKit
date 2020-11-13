//
//  EventTableViewCell.swift
//  FavouriteEvents
//
//  Created by Charlie Nguyen on 02/11/2020.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
   var eventFav = false {
        didSet {
            UserDefaults.standard.set(eventFav, forKey: "eventFav")
            self.updateFavouriteButton()
        }
    }

    
    @IBOutlet var eventImageView: UIImageView!
    @IBOutlet var eventNameLabel: UILabel!
    @IBOutlet var startDateLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        self.eventFav.toggle()
    }
    
    private func updateFavouriteButton() {
        let title = self.eventFav ? "Favourite" : "Unfavourite"
        self.favoriteButton.setTitle(title, for: .normal)
        
    }

}
