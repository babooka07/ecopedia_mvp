//
//  NavigationToPointViewController.swift
//  Ecopedia_MVP
//
//  Created by Anatoliy Anatolyev on 09.12.2018.
//  Copyright © 2018 Valeriy. All rights reserved.
//

import UIKit
import CoreLocation


class NavigationToPointViewController: UIViewController {

    
    @IBOutlet weak var navigationArrowView: UIImageView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    var currentItemModel = ItemModel()
    
    private var locationManager = CLLocationManager()
    private var currentNorthDegreeseAngle = 0.0
    private var currentLocation = CLLocation()
    private var destinationLocation = CLLocation()
    
    
    @IBOutlet weak var testLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        testLabel.text = currentItemModel.name
        destinationLocation = CLLocation(latitude: currentItemModel.coords.latitude, longitude: currentItemModel.coords.longitude)
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.distanceFilter = 0
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()

        
    }
    private func updateDistance () {
        distanceLabel.text = "Distance: \(Int(currentLocation.distance(from: destinationLocation))) m"
    }
    
    private func setDirection() {
        let direction = (getBearingBetweenTwoPoints() - currentNorthDegreeseAngle) * .pi/180
        UIView.animate(withDuration: 0.5) {
            self.navigationArrowView.transform = CGAffineTransform(rotationAngle: CGFloat(direction))
        }
        
    }
    
    
    private func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    private  func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    private  func getBearingBetweenTwoPoints() -> Double {
        
        let lat1 = degreesToRadians(degrees: currentLocation.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: currentLocation.coordinate.longitude)
        
        let lat2 = degreesToRadians(degrees: destinationLocation.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: destinationLocation.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return radiansToDegrees(radians: radiansBearing)
    }
    
    
    @IBAction func cancelBtnDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension NavigationToPointViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        currentNorthDegreeseAngle = newHeading.trueHeading
        updateDistance()
        //MARK: TODO сделать безопасным
        setDirection()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        currentLocation = location
//     print(location.coordinate.latitude, location.coordinate.longitude)
    }
    
}


