//
//  LocationController.swift
//  Maralog
//
//  Created by Ilias Basha on 2/7/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation


class LocationController: NSObject, UpdateContactDelegate {
    
    static let sharedInstance = LocationController()
    
    var delegate = AddContactsViewController()
    
    var contact: Contact?
    
    override init() {
        super.init()
        locationManager.delegate = self
        self.contact = delegate.contact
    }
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    
    func requestCurrentLocation() {
        locationManager.requestLocation()
    }
    
    
    func updateContact(contact: Contact){
        self.contact = contact
    }

}


extension LocationController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
        
        if let currentLocation = currentLocation {
            
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks, error) in
                if error != nil {
                    print("Reverse geocoder failed with error: \(error?.localizedDescription)")
                }
                guard let placemarks = placemarks else { return }
                if placemarks.count > 0 {
                    self.locationManager.stopUpdatingLocation()
                    let pm = placemarks[0] as CLPlacemark
                    if let currentLocation = pm.locality {
                        print(currentLocation)
                    }
                }
            })
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
}



