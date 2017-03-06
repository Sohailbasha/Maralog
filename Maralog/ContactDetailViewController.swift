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
    
    var usersLocation: Location? {
        return contact?.location
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.updateViews()
    }
    
    func updateViews() {
        guard let contact = self.contact,
            let firstName = contact.firstName as String?,
            let lastName = contact.lastName as String?,
            let number = contact.phoneNumber as String?,
            let timeStamp = contact.timeStamp as? Date else { return }
        
        
            fullName.text = "\(firstName) \(lastName)"
            phoneNumber.text = number
            timeMetLabel.text = ""
            locationMetLabel.text = ""
        
        
        if contact.location != nil {
    
            if let location = contact.location {
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
                        if let city = pm.locality,
                            let state = pm.administrativeArea,
                            let street = pm.thoroughfare,
                            let zipcode = pm.postalCode {
                            self.locationMetLabel.text = "location met: \(street). \(city), \(state) \(zipcode)"
                            self.timeMetLabel.text = "\(self.formatter.string(from: timeStamp))"
                        }
                    }
                }
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
    
    
    
    // MARK: - Actions
    
    @IBAction func callButtonTapped(_ sender: Any) {
        let callNumber: String = phoneNumber.text ?? ""
        if let phoneURL = URL(string: "tel://\(callNumber)") {
            let application: UIApplication = UIApplication.shared
            if application.canOpenURL(phoneURL) {
                application.open(phoneURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    // menu actions
    
    @IBAction func editContact(_ sender: Any) {
        editMenuView.frame.origin.x = 380
        editMenuView.center.y = self.view.center.y
        self.view.addSubview(editMenuView)

        UIView.animate(withDuration: 0.75) {
            self.editMenuView.center.x = self.view.center.x
        }
        editPhoneTextField.text = contact?.phoneNumber
        editFirstNameTextField.text = contact?.firstName
        editLastNameTextField.text = contact?.lastName
    }
    

    @IBAction func saveMenuButtonTapped(_ sender: Any) {
        if let contact = contact {
            guard let firstName = editFirstNameTextField.text,
                let lastName = editLastNameTextField.text,
                let number = editPhoneTextField.text,
                let userLocation = self.usersLocation else {
                return}
            
            
            ContactController.sharedInstance.update(contact: contact, firstName: firstName, lastName: lastName, phoneNumber: number, location: userLocation)
            fullName.text = "\(firstName) \(lastName)"
            phoneNumber.text = number
        }
        removeMenuView()
    }

    
    @IBAction func exitButtonTapped(_ sender: Any) {
        removeMenuView()
    }
    
    
    
    // MARK: - Outlets
    
    @IBOutlet var fullName: UILabel!
    @IBOutlet var phoneNumber: UILabel!
    @IBOutlet var locationMetLabel: UILabel!
    @IBOutlet var timeMetLabel: UILabel!
    
    // edit contact view
    @IBOutlet var editMenuView: UIView!
    @IBOutlet var editPhoneTextField: UITextField!
    @IBOutlet var editFirstNameTextField: UITextField!
    @IBOutlet var editLastNameTextField: UITextField!
}

extension ContactDetailViewController {
    func removeMenuView() {
        UIView.animate(withDuration: 0.75, animations: {
            self.editMenuView.frame.origin.x = -400
        }) { (_) in
            self.editMenuView.removeFromSuperview()
        }
    }
}
