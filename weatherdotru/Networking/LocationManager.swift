//
//  LocationManager.swift
//  weatherdotru
//
//  Created by Pestrikov Anton 13.12.2023
//

import UIKit
import CoreLocation

extension Notification.Name {
    static let locationDidUpdate = Notification.Name("locationDidUpdate")
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    //MARK: - Variables
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    private var customAccuracy: CLLocationAccuracy = kCLLocationAccuracyKilometer
    var currentLocation = CLLocationCoordinate2D()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location.coordinate
            NotificationCenter.default.post(name: .locationDidUpdate, object: location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(AppStrings.error):: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    //MARK: - Helper Methods
    func requestAuthorizationStatus() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func updateAccuracy() {
        if UIApplication.shared.applicationState == .active {
            customAccuracy = kCLLocationAccuracyKilometer
        } else {
            customAccuracy = kCLLocationAccuracyThreeKilometers
        }
        locationManager.desiredAccuracy = customAccuracy
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func checkLocationAccessibility() -> Bool {
      return locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse
    }
    
}
