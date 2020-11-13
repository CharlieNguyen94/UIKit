//
//  Protocols.swift
//  FavouriteEvents
//
//  Created by Charlie Nguyen on 04/11/2020.
//

import Foundation
import UIKit

protocol ButtonPresentable {
    var eventFav: Bool! { get set }
    
    var favouriteButton: UIButton! { get set }
    func updateFavouriteButton()
}

extension ButtonPresentable {
    func updateFavouriteButton() {
        let title = self.eventFav ? "Favourite" : "Unfavourite"
        self.favouriteButton.setTitle(title, for: .normal)
    }
    
}
