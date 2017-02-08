//
//  ContactDetailViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 2/7/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit
import CoreLocation

class ContactDetailViewController: UIViewController {
    
    var contact: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let contact = self.contact {
            self.updateWithContact(contact: contact)
        }
    }
    
    
    func updateWithContact(contact: Contact) {
        
        guard let firstName = contact.firstName as String?,
            let lastName = contact.lastName as String?,
            let number = contact.phoneNumber as String?,
            let timeStamp = contact.timeStamp as? Date else { return }
        
        
        
        if contact.location == nil {
            fullName.text = "\(firstName) \(lastName)"
            phoneNumber.text = number
            timeMetLabel.text = "added \(formatter.string(from: timeStamp))"
            
        } else {
            
            if let location = contact.location {
                //let coordinate = LocationController.sharedInstance.getCoordinates(contact: contact)
                let coordinate = LocationController.sharedInstance.getLocationCoordinates(location: location)
                
                let currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                
                let geocoder = CLGeocoder()
                
                geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
                    if let error = error {
                        print("Reverse geocoder failed with error: \(error.localizedDescription)")
                    }
                    
                    guard let placemarks = placemarks else {
                        return
                    }
                    
                    if placemarks.count > 0 {
                        let pm = placemarks[0] as CLPlacemark
                        if let currentLocation = pm.locality {
                            self.locationMetLabel.text = currentLocation
                        }
                    }
                }
                
                fullName.text = "\(firstName) \(lastName)"
                phoneNumber.text = number
                timeMetLabel.text = "added \(formatter.string(from: timeStamp))"
            }
        }
        
        
    }
    
    
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter
    } ()
    
    
    
    
    // MARK: - Outlets
    
    @IBOutlet var fullName: UILabel!
    @IBOutlet var phoneNumber: UILabel!
    @IBOutlet var locationMetLabel: UILabel!
    @IBOutlet var timeMetLabel: UILabel!
}
