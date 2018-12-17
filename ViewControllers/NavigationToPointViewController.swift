//
//  NavigationToPointViewController.swift
//  Ecopedia_MVP
//
//  Created by Anatoliy Anatolyev on 09.12.2018.
//  Copyright © 2018 Valeriy. All rights reserved.
//

import UIKit
import CoreLocation


class NavigationToPointViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var navigationArrowView: UIImageView!
    
    var currentItemModel = ItemModel()
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var testLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        testLabel.text = currentItemModel.name
        
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        let degrees = 360 - newHeading.magneticHeading
        let radians = CGFloat(degrees * Double.pi / 180)
        
        navigationArrowView.transform = CGAffineTransform(rotationAngle: radians)
    }
    
    
    @IBAction func cancelBtnDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
