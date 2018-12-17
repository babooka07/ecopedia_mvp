//
//  PoiListTableViewCell.swift
//  Ecopedia_MVP
//
//  Created by Anatoliy Anatolyev on 11.12.2018.
//  Copyright © 2018 Valeriy. All rights reserved.
//

import UIKit

class PoiListTableViewCell: UITableViewCell {

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
