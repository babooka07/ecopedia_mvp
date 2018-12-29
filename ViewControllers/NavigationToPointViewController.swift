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

    @IBOutlet weak var noGPSdataView: UIView!
    
    @IBOutlet weak var gpsSignalIndicator_1: UIView!
    @IBOutlet weak var gpsSignalIndicator_2: UIView!
    @IBOutlet weak var gpsSignalIndicator_3: UIView!
    @IBOutlet weak var gpsSignalIndicator_4: UIView!
    
    @IBOutlet weak var navigationArrowView: UIImageView!
    
    @IBOutlet weak var accuracyLabel: UILabel!
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
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        gpsSignalIndicator_1.alpha = 0
        gpsSignalIndicator_2.alpha = 0
        gpsSignalIndicator_3.alpha = 0
        gpsSignalIndicator_4.alpha = 0
        
        if CLLocationManager.locationServicesEnabled(), CLLocationManager.headingAvailable() {
            
            locationManager.requestAlwaysAuthorization()
            locationManager.delegate = self
            determinePermissions()
           
        } else {
            proceedGpsServiceUnavailableAlert()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    private func determinePermissions() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            initializeNavigation()
        case .authorizedWhenInUse:
            initializeNavigation()
//        case .denied:
//            print("denied")
//        case .notDetermined:
//            print("notDetermined")
//        case .restricted:
//            print("restricted")
            
        default:
            proceedNoGpsAccess()
            
        }
    }
    
    private func initializeNavigation() {
        
        locationManager.distanceFilter = 0
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        noGPSdataView.alpha = 0

    }
    
    private func proceedNoGpsAccess() {
        let alert = UIAlertController(title: "NO GPS DATA", message: "Для пользования сервисом, пожалуйста, разрешите приложению использовать вашу геопозицию", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (alrt) in
            //код, открывающий настройки
        }
        alert.addAction(settingsAction)
        
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func proceedGpsServiceUnavailableAlert(){
        let alert = UIAlertController(title: "NO GPS", message: "Ваше устройство не поддерживает этот сервис", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    private func updateDistance () {
        distanceLabel.text = "Distance: \(Int(currentLocation.distance(from: destinationLocation))) m"
    }
    
    private func updateAccuracy() {
        
        accuracyLabel.text = "Accuracy: ± \(Int(currentLocation.horizontalAccuracy)) m"
       
        if currentLocation.horizontalAccuracy < 0 || currentLocation.horizontalAccuracy >= 20
        {
            gpsSignalIndicator_1.alpha = 1
            gpsSignalIndicator_2.alpha = 0
            gpsSignalIndicator_3.alpha = 0
            gpsSignalIndicator_4.alpha = 0
            
            gpsSignalIndicator_1.backgroundColor = UIColor.red
        }
        else if currentLocation.horizontalAccuracy >= 15
        {
            gpsSignalIndicator_1.alpha = 1
            gpsSignalIndicator_2.alpha = 1
            gpsSignalIndicator_3.alpha = 0
            gpsSignalIndicator_4.alpha = 0
            
            gpsSignalIndicator_1.backgroundColor = UIColor.yellow
            gpsSignalIndicator_2.backgroundColor = UIColor.yellow
            
        }
        else if currentLocation.horizontalAccuracy >= 10
        {
            gpsSignalIndicator_1.alpha = 1
            gpsSignalIndicator_2.alpha = 1
            gpsSignalIndicator_3.alpha = 1
            gpsSignalIndicator_4.alpha = 0
            
            gpsSignalIndicator_1.backgroundColor = UIColor.yellow
            gpsSignalIndicator_2.backgroundColor = UIColor.yellow
            gpsSignalIndicator_3.backgroundColor = UIColor.yellow
        }
        else
        {
            gpsSignalIndicator_1.alpha = 1
            gpsSignalIndicator_2.alpha = 1
            gpsSignalIndicator_3.alpha = 1
            gpsSignalIndicator_4.alpha = 1
            
            gpsSignalIndicator_1.backgroundColor = UIColor.green
            gpsSignalIndicator_2.backgroundColor = UIColor.green
            gpsSignalIndicator_3.backgroundColor = UIColor.green
            gpsSignalIndicator_4.backgroundColor = UIColor.green
            
        }
    }
    
    
    private func setDirection() {
        let direction = (getBearingBetweenTwoPoints() - currentNorthDegreeseAngle) * .pi/180
        UIView.animate(withDuration: Consts.serviceViewAnimationsDuration) {
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
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        currentNorthDegreeseAngle = newHeading.trueHeading
        updateDistance()
        updateAccuracy()
        setDirection()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        currentLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        determinePermissions()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            switch error.code {
            default:
                break
            }
        }
    }
    
}

