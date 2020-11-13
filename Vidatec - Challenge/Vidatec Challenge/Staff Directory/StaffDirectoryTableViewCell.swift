//
//  StaffDirectoryTableViewCell.swift
//  Vidatec Challenge
//
//  Created by Charlie N on 01/08/2019.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

class StaffDirectoryTableViewCell: UITableViewCell {

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var jobLabel: UILabel!
    
    override func prepareForReuse() {
        
        // reset/clear contents of Labels and ImageView
        avatarImageView.image = #imageLiteral(resourceName: "default_avatar") // Using image literal with a black icon and opaque background
        fullNameLabel.text = nil
        jobLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        contentView.backgroundColor = selected ? .theme : .clear
        
        fullNameLabel.textColor = selected ? .white : .black
        jobLabel.textColor = selected ? .white : .black
    }
    
    

}
