//
//  anilmalListTableViewCell.swift
//  Ecopedia_MVP
//
//  Created by Anatoliy Anatolyev on 10.12.2018.
//  Copyright © 2018 Valeriy. All rights reserved.
//

import UIKit

class anilmalListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var animalImageView: UIImageView!
    
    @IBOutlet weak var okIndicatorImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
}
