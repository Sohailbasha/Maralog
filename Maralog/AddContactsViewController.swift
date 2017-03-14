//
//  AddContactsViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 2/6/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit
import CoreLocation
import Contacts

class AddContactsViewController: UIViewController, CLLocationManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreLocationManager = CLLocationManager()
        coreLocationManager.delegate = self
        coreLocationManager.startUpdatingLocation()
        coreLocationManager.requestWhenInUseAuthorization()
        
        
        
        self.transparentNavBar()
        self.detailLabelsAreInvisible()
        
        uiSwitch.isOn = false
        syncToContactsSwitch.isOn = false
        autoTextSwitch.isOn = false
        
        autoTextIcon.tintColor = .gray
        syncIcon.tintColor = .gray
        locationIcon.tintColor = .gray
        
        phoneNumberTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
    }
    
    
    // MARK: - Properties
    
    var coreLocationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var usersLocation: Location?
    
    let store = CNContactStore()
    
    
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
    
    // Icons
    @IBOutlet var locationIcon: UIImageView!
    @IBOutlet var autoTextIcon: UIImageView!
    @IBOutlet var syncIcon: UIImageView!
    
    
    // MARK: - Action
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespaces).capitalized,
            let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespaces).capitalized,
            let phoneNumber = phoneNumberTextField.text as String? else { return }
        
        if uiSwitch.isOn {
            if let location = usersLocation {
                let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, location: location)
                ContactController.sharedInstance.addContact(contact: contact)
            }
        } else {
            let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
            ContactController.sharedInstance.addContact(contact: contact)
        }
        
        
        syncToContactsSwitch.isOn ? addToAddressBook(firstName: firstName,
                                                     lastName: lastName,
                                                     phoneNumber: phoneNumber) : ()
        
        
        autoTextSwitch.isOn ? sendAutoTextTo(phoneNumber: phoneNumber,
                                             firstName: firstName) : goToRootView()
    }
    
    @IBAction func locationSwitchEnabled(_ sender: Any) {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            uiSwitch.setOn(false, animated: true)
            permissionsAlert(title: "Location Services Are Off", message: "Enabel access to save location")
        }
        
        if uiSwitch.isOn == false {
            locationIcon.tintColor = .gray
        } else {
            locationIcon.tintColor = .white
        }
    }
    
    @IBAction func syncSwitchEnabled(_ sender: Any) {
        store.requestAccess(for: .contacts) { (granted, error) in
            if !granted {
                self.syncToContactsSwitch.setOn(false, animated: true)
                self.permissionsAlert(title: "Contacts Access Disabled", message: "Enable access to contacts to sync")
            }
        }
        
        if syncToContactsSwitch.isOn == false {
            syncIcon.tintColor = .gray
        } else {
            syncIcon.tintColor = .white
        }
        
    }
    
    @IBAction func autoTextSwitchEnabled(_ sender: Any) {
        if autoTextSwitch.isOn == false {
            autoTextIcon.tintColor = .gray
        } else {
            autoTextIcon.tintColor = .white
        }
    }
    
}



//MARK: - Major Helper Methods

extension AddContactsViewController {
    
    
    // MARK: - Features
    
    func sendAutoTextTo(phoneNumber: String, firstName: String) {
        if(MessageSender.sharedInstance.canSendText()) {
            
            let yourName = UserController.sharedInstance.getName()
            MessageSender.sharedInstance.recepients.append(phoneNumber)
            MessageSender.sharedInstance.textBody = "Hi \(firstName.capitalized), it's \(yourName)"
            let messageComposerVC = MessageSender.sharedInstance.configuredMessageComposeViewController()
            present(messageComposerVC,
                    animated: true,
                    completion: { _ = self.navigationController?.popToRootViewController(animated: true) })
        } else {
            return
        }
    }
    
    func addToAddressBook(firstName: String, lastName: String, phoneNumber: String) {
        let contact = CNMutableContact()
        contact.givenName = firstName.capitalized
        contact.familyName = lastName.capitalized
        
        contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: phoneNumber))]
        contact.note = "Added with Astrea"
        
//        let dateMet = NSDateComponents()
//        dateMet.month = Calendar.current.component(.month, from: Date())
//        dateMet.year = Calendar.current.component(.year, from: Date())
//        dateMet.day = Calendar.current.component(.day, from: Date())

//        let met = CNLabeledValue(label: "Date met", value: dateMet)
//        contact.dates = [met]
        
        
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
                usersLocation = Location(latitude: Double(currentLocation.coordinate.latitude), longitude: Double(currentLocation.coordinate.longitude), name: "")
            }
        }
        coreLocationManager.stopUpdatingLocation()
    }
}

// MARK: - TextField Methods

extension AddContactsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if firstNameTextField.isEditing {
           UIView.animate(withDuration: 1, delay: 1, options: .curveEaseIn, animations: {
            self.labelOfFirstName.isHidden = false }, completion: nil)
        }
        
        if lastNameTextField.isEditing {
            UIView.animate(withDuration: 1, delay: 1, options: .curveEaseIn, animations: {
                self.labelOfLastName.isHidden = false }, completion: nil)
        }
        
        if phoneNumberTextField.isEditing {
            UIView.animate(withDuration: 1, delay: 1, options: .curveEaseIn, animations: {
                self.labelOfPhoneNumber.isHidden = false }, completion: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let fNameText = firstNameTextField.text else { return }
        guard let lNameText = lastNameTextField.text else { return }
        guard let pNumberText = phoneNumberTextField.text else { return }
        
        if fNameText.isEmpty {
            UIView.animate(withDuration: 1, delay: 1, options: .curveEaseIn, animations: {
                self.labelOfFirstName.isHidden = true }, completion: nil)
        }
        if lNameText.isEmpty {
            UIView.animate(withDuration: 1, delay: 1, options: .curveEaseIn, animations: {
                self.labelOfLastName.isHidden = true }, completion: nil)
        }
        if pNumberText.isEmpty {
            UIView.animate(withDuration: 1, delay: 1, options: .curveEaseIn, animations: {
                self.labelOfPhoneNumber.isHidden = true }, completion: nil)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: - Minor Methods

extension AddContactsViewController {
    
    func permissionsAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let enable = UIAlertAction(title: "Enable", style: .default) { (_) in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(enable)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func goToRootView() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func transparentNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    func detailLabelsAreInvisible() {
        self.labelOfPhoneNumber.isHidden = true
        self.labelOfFirstName.isHidden = true
        self.labelOfLastName.isHidden = true
    }
    
}















