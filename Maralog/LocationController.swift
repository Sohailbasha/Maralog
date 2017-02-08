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


class LocationController: NSObject {
    
    static let sharedInstance = LocationController()
    
    var delegate = AddContactsViewController()
    
    var contact: Contact?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?

    func saveLocation(location: Location) {
        ContactController.sharedInstance.saveToMemory()
    }
    
    func requestCurrentLocation() {
        locationManager.requestLocation()
    }
    
    
    func updateContact(contact: Contact){
        self.contact = contact
    }
    
    
    func getCoordinates(contact: Contact) -> CLLocationCoordinate2D {
        var coordinates = CLLocationCoordinate2D()
        
        if let lat = contact.location?.latitude, let long = contact.location?.longitude {
            let latitude = CLLocationDegrees(lat)
            let longitude = CLLocationDegrees(long)
            coordinates.latitude = latitude
            coordinates.longitude = longitude
        }
        
        return coordinates
    }
    
    
    func getLocationCoordinates(location: Location) -> CLLocationCoordinate2D {
        let latitude = CLLocationDegrees(location.latitude)
        let longitude = CLLocationDegrees(location.longitude)
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}


extension LocationController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        
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



