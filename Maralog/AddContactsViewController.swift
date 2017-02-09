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

class AddContactsViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coreLocationManager = CLLocationManager()
        coreLocationManager.delegate = self
        coreLocationManager.startUpdatingLocation()
        coreLocationManager.requestWhenInUseAuthorization()
        
        self.transparentNavBar()
        self.detailLabelsAreInvisible()
        
        let letters = "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z #"
        let sections = letters.components(separatedBy: " ")
        
    }
    
    
    
    // MARK: - Properties
    
    var coreLocationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var usersLocation: Location?
    
    
    
    // MARK: - Outlets
    
    // text fields
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    
    // labels for textfields
    @IBOutlet var labelOfPhoneNumber: UILabel!
    @IBOutlet var labelOfFirstName: UILabel!
    @IBOutlet var labelOfLastName: UILabel!
    
    @IBOutlet var uiSwitch: UISwitch!
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            coreLocationManager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            if let currentLocation = currentLocation {
                usersLocation = Location(latitude: Double(currentLocation.coordinate.latitude), longitude: Double(currentLocation.coordinate.longitude), name: "")
            }
        }
    }
    
    
    
    // MARK: - Action
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let phoneNumber = phoneNumberTextField.text as String? else { return }
        
        if uiSwitch.isOn {
            
            
            if let location = usersLocation {
                let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, location: location)
                
                
                ContactController.sharedInstance.add(location: location, with: contact)
            }
            
        } else {
            
            let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
            ContactController.sharedInstance.addContact(contact: contact)
        }
        
        _ = navigationController?.popToRootViewController(animated: true)
    }
}



//MARK: - Asthetics & Animation

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
    
    
}

