//
//  AvatarImageTableViewCell.swift
//  Vidatec Challenge
//
//  Created by Charlie N on 01/08/2019.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

class AvatarImageTableViewCell: UITableViewCell {

 @IBOutlet var avatarImageView: UIImageView!
    
    override func prepareForReuse() {
        avatarImageView.image = #imageLiteral(resourceName: "default_avatar")
    }
    
    func configuire(using favouriteColour: String) {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 1.9
        avatarImageView.layer.borderWidth = 5.0
        avatarImageView.layer.borderColor = UIColor.theme.cgColor
        
        backgroundColor = UIColor(hex: favouriteColour)
        layer.cornerRadius = 15.0
    }
    
    func update(_ image: UIImage?) {
        avatarImageView.image = image
    }

}
