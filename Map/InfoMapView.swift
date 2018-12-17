//
//  InfoMapView.swift
//  Ecopedia_MVP
//
//  Created by Anatoliy Anatolyev on 09.12.2018.
//  Copyright © 2018 Valeriy. All rights reserved.
//

import UIKit

protocol InfoMapViewDelegate: class {
    func infoMapCancelDidTap()
    func infoMapSgowDirectDidTap()
    
}

class InfoMapView: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    weak var delegate: InfoMapViewDelegate?
    
    
    @IBAction func cancelBtnDidTap() {
        delegate?.infoMapCancelDidTap()
    }
    
    
    @IBAction func showDirectionBtnDidTap() {
        delegate?.infoMapSgowDirectDidTap()
    }
    
    
}
