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
    
    
    
    // sharedInstance in AddContactVC
    
        
    
    func createCoordinate(location: Location) -> CLLocationCoordinate2D {
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        return coordinate
    }
    

    func removeLocation(location: Location, of contact: Contact) {
        if let moc = contact.managedObjectContext {
            moc.delete(location)
        }
    }
    
    
    
    
    
}
