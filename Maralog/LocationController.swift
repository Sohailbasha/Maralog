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


class LocationController {
    
    static let sharedInstance = LocationController()

    
    
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
