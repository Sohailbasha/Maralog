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
        
        
//        
//        guard let location = contact.location else {
//            return
//        }
//        
//        let coordinate = LocationController.sharedInstance.createCoordinate(location: location)
//        
//        let currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//        
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
//            
//            if let error = error {
//                print("Error reverse geocoding: \(error)")
//                return
//            }
//            
//            if let placemarks = placemarks {
//                
//                if placemarks.count > 0 {
//                    guard let placemark = placemarks.first else { return }
//                    self.locationMetLabel.text = placemark.locality
//                }
//                
//            }
//            
//        }
//        
        
        fullName.text = "\(firstName) \(lastName)"
        phoneNumber.text = number
        timeMetLabel.text = "added \(formatter.string(from: timeStamp))"
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
