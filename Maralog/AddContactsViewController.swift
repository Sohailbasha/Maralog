//
//  AddContactsViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 2/6/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit
import CoreData
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
    }
    
    
    
    // MARK: - Properties
    
    var coreLocationManager: CLLocationManager!
    var currentLocation: Location?
    
    
    
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
        if let location = locations.last {
            
            currentLocation = Location(latitude: Double(location.coordinate.latitude), longitude: Double(location.coordinate.longitude), name: "")
            
            //currentLocation = CustomAnnotation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, name: "My Location")
//            if let currentLocation = currentLocation {
//                mapView.showAnnotations([favoriteCity, currentLocation], animated: true)
//            }
        }
    }
    
    
    
    // MARK: - Action
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let phoneNumber = phoneNumberTextField.text else { return }
        
        if uiSwitch.isOn {
            if let location = currentLocation {
                let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, timeStamp: Date(), location: location)
                ContactController.sharedInstance.addContact(contact: contact)
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

