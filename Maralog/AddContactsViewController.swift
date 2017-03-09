//
//  AddContactsViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 2/6/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Contacts

class AddContactsViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreLocationManager = CLLocationManager()
        coreLocationManager.delegate = self
        coreLocationManager.startUpdatingLocation()
        coreLocationManager.requestWhenInUseAuthorization()
        
        self.transparentNavBar()
        self.detailLabelsAreInvisible()
    }
    
    
    // MARK: - Properties
    var coreLocationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var usersLocation: Location?
    
    
    // MARK: - Outlets
    
    // Text Fields
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    
    // Labels for each Text Field
    @IBOutlet var labelOfPhoneNumber: UILabel!
    @IBOutlet var labelOfFirstName: UILabel!
    @IBOutlet var labelOfLastName: UILabel!
    
    // Switches
    @IBOutlet var uiSwitch: UISwitch!
    @IBOutlet var autoTextSwitch: UISwitch!
    @IBOutlet var syncToContactsSwitch: UISwitch!
    
    
    // MARK: - Action
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespaces),
            let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespaces),
            let phoneNumber = phoneNumberTextField.text as String? else { return }
        
        // LOCATION
        if uiSwitch.isOn {
            if let location = usersLocation {
                let contact = Contact(firstName: firstName.capitalized,
                                      lastName: lastName.capitalized,
                                      phoneNumber: phoneNumber,
                                      location: location)
            
                ContactController.sharedInstance.addContact(contact: contact)
            }
        } else {
            let contact = Contact(firstName: firstName.capitalized,
                                  lastName: lastName.capitalized,
                                  phoneNumber: phoneNumber)
            
            ContactController.sharedInstance.addContact(contact: contact)
        }
    
        // SYNC
        if syncToContactsSwitch.isOn {
            self.addToAddressBook(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
        }
        
        // TEXT
        if autoTextSwitch.isOn {
            sendAutoTextTo(phoneNumber: phoneNumber, firstName: firstName)
        } else {
            _ = navigationController?.popToRootViewController(animated: true)
        }
    }
}



//MARK: - Helper Methods

extension AddContactsViewController {
    
    func transparentNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    func detailLabelsAreInvisible() {
        self.labelOfPhoneNumber.alpha = 0
        self.labelOfFirstName.alpha = 0
        self.labelOfLastName.alpha = 0
    }
    
    func sendAutoTextTo(phoneNumber: String, firstName: String) {
        if(MessageSender.sharedInstance.canSendText()) {
            MessageSender.sharedInstance.recepients.append(phoneNumber)
            MessageSender.sharedInstance.textBody = "Hi \(firstName.capitalized) it's"
            let messageComposerVC = MessageSender.sharedInstance.configuredMessageComposeViewController()
            present(messageComposerVC,
                    animated: true,
                    completion: { _ = self.navigationController?.popToRootViewController(animated: true) })
        }
    }
    
    func addToAddressBook(firstName: String, lastName: String, phoneNumber: String) {
        let contact = CNMutableContact()
        contact.givenName = firstName.capitalized
        contact.familyName = lastName.capitalized
        contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberiPhone, value: CNPhoneNumber(stringValue: phoneNumber))]
        contact.note = "Added with Astrea"
        
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        try? store.execute(saveRequest)
    }
    
}


// MARK: - Location Manager 

extension AddContactsViewController {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            coreLocationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = CLLocation(latitude: location.coordinate.latitude,
                                         longitude: location.coordinate.longitude)
            
            if let currentLocation = currentLocation {
                usersLocation = Location(latitude: Double(currentLocation.coordinate.latitude),
                                         longitude: Double(currentLocation.coordinate.longitude),
                                         name: "")
            }
        }
        coreLocationManager.stopUpdatingLocation()
    }
}



















