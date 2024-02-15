//
//  LocationManager.swift
//  weather-app
//
//  Created by Sam on 2024-02-01.
//

import Foundation
import CoreLocation
import Observation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    var location: CLLocation?
    var address: CLPlacemark?
    var authorized = false
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation() {
        if locationManager.authorizationStatus == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestLocation()
        }
    }
    
    func reverseGeocodeLocation(_ location: CLLocation){
        Task{
            let placemarks = try? await geocoder.reverseGeocodeLocation(location)
            address = placemarks?.last
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus != .denied {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        if let location {
            reverseGeocodeLocation(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
