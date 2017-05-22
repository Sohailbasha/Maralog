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
        
        self.detailLabelsAreInvisible()
        
        phoneNumberTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        self.allign(label: labelOfFirstName, with: firstNameTextField)
        self.allign(label: labelOfLastName, with: lastNameTextField)
        self.allign(label: labelOfPhoneNumber, with: phoneNumberTextField)
        
        if isLocationDefaultOn == true {
            uiSwitch.isOn = true
            locationIcon.tintColor = .black
            
        } else {
            uiSwitch.isOn = false
            locationIcon.tintColor = .gray
            
        }
        
        if isAutoTextDefaultOn == true {
            autoTextSwitch.isOn = true
            autoTextIcon.tintColor = .black
            
            
        } else {
            autoTextSwitch.isOn = false
            autoTextIcon.tintColor = .gray
            
        }
    }
    
    
    
    let notificaitonView: UIView = UIView()

    let notificationLabel: UILabel = UILabel()
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if isLocationDefaultOn == true {
            uiSwitch.isOn = true
        } else {
            uiSwitch.isOn = false
        }
        
        if isAutoTextDefaultOn == true {
            autoTextSwitch.isOn = true
        } else {
            autoTextSwitch.isOn = false
        }
    
        
    }
    
    
    // MARK: - Properties
    
    var coreLocationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var usersLocation: Location?
    
    let store = CNContactStore()
    let address = CNMutablePostalAddress()
    
    var isLocationDefaultOn: Bool {
        return SettingsController.sharedInstance.getLocationSetting()
    }
    
    var isAutoTextDefaultOn: Bool {
        return SettingsController.sharedInstance.getTextSetting()
    }
    
    
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
    
    
    // Icons
    @IBOutlet var locationIcon: UIImageView!
    @IBOutlet var autoTextIcon: UIImageView!
    
    

    
    
    // MARK: - Action
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespaces).capitalized,
            let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespaces).capitalized,
            let phoneNumber = phoneNumberTextField.text as String? else { return }
        
        
        if (!firstName.isEmpty && !phoneNumber.isEmpty) {
            if uiSwitch.isOn {
                if let location = usersLocation {
                    let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, location: location)
                    ContactController.sharedInstance.addContact(contact: contact)
                    addToCNContacts(contact: contact)
                }
            } else {
                let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
                ContactController.sharedInstance.addContact(contact: contact)
                addContactWithoutAddress(contact: contact)
            }
            autoTextSwitch.isOn ? sendAutoTextTo(phoneNumber: phoneNumber, firstName: firstName) : ()
        } else {
            
            if firstName.isEmpty {
                self.hilightEmpty(firstNameTextField)
            }
            
            if phoneNumber.isEmpty {
                self.hilightEmpty(phoneNumberTextField)
            }

        }
    }
    
    @IBAction func locationSwitchEnabled(_ sender: Any) {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            uiSwitch.setOn(false, animated: true)
            permissionsAlert(title: "Location Services Are Off", message: "Enabel access to save location")
        }
        
        if uiSwitch.isOn == false {
            locationIcon.tintColor = .gray
        } else {
            locationIcon.tintColor = .black
            saveLocationToContact()
        }
    }
    
    @IBAction func autoTextSwitchEnabled(_ sender: Any) {
        if autoTextSwitch.isOn == false {
            autoTextIcon.tintColor = .gray
        } else {
            autoTextIcon.tintColor = .black
        }
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
        if let location = locations.last {
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


// MARK: - TEXTFIELD DELEGATE METHODS

extension AddContactsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if firstNameTextField.isEditing {
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: [], animations: {
                self.labelOfFirstName.isHidden = false
                self.labelOfFirstName.frame.origin.y = self.firstNameTextField.frame.origin.y - self.labelOfFirstName.layer.bounds.height
            }, completion: nil)
        }
        
        if lastNameTextField.isEditing {
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: [], animations: {
                self.labelOfLastName.isHidden = false
                self.labelOfLastName.frame.origin.y = self.lastNameTextField.frame.origin.y - self.labelOfLastName.layer.bounds.height
            }, completion: nil)
        }
        
        if phoneNumberTextField.isEditing {
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: [], animations: {
                self.labelOfPhoneNumber.isHidden = false
                self.labelOfPhoneNumber.frame.origin.y = self.phoneNumberTextField.frame.origin.y - self.labelOfPhoneNumber.layer.bounds.height
            }, completion: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let fNameText = firstNameTextField.text else { return }
        guard let lNameText = lastNameTextField.text else { return }
        guard let pNumberText = phoneNumberTextField.text else { return }
        
        if fNameText.isEmpty {
            UIView.animate(withDuration: 0.25, animations: {
                self.allign(label: self.labelOfFirstName, with: self.firstNameTextField)
                self.labelOfFirstName.isHidden = true
            }, completion: nil)
        }
        
        if lNameText.isEmpty {
            UIView.animate(withDuration: 0.25, animations: {
                self.allign(label: self.labelOfLastName, with: self.lastNameTextField)
                self.labelOfLastName.isHidden = true
            }, completion: nil)
        }
        if pNumberText.isEmpty {
            UIView.animate(withDuration: 0.25, animations: {
                self.allign(label: self.labelOfPhoneNumber, with: self.phoneNumberTextField)
                self.labelOfPhoneNumber.isHidden = true
            }, completion: nil)
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




// MARK: - HELPER METHODS

extension AddContactsViewController {
    
    func sendAutoTextTo(phoneNumber: String, firstName: String) {
        if(MessageSender.sharedInstance.canSendText()) {
            let yourName = UserController.sharedInstance.getName()
            MessageSender.sharedInstance.recepients.append(phoneNumber)
            MessageSender.sharedInstance.textBody = "Hi \(firstName.capitalized), it's \(yourName)"
            let messageComposerVC = MessageSender.sharedInstance.configuredMessageComposeViewController()
            
            DispatchQueue.main.async {
                self.present(messageComposerVC,
                             animated: true,
                             completion: { _ = self.navigationController?.popToRootViewController(animated: true) })
            }
            
        } else {
            return
        }
    }
    
    func saveLocationToContact() {
        let geocoder = CLGeocoder()
        guard let currentLocation = currentLocation else {
            return }
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if let error = error {
                print("error reverse geocoding: \(error)")
            }
            
            if let placemarks = placemarks {
                if placemarks.count > 0 {
                    let pm = placemarks[0] as CLPlacemark
                    guard let city = pm.locality,
                        let state = pm.administrativeArea,
                        let street = pm.thoroughfare,
                        let zipcode = pm.postalCode else {
                            return }
                    
                    self.address.street = street
                    self.address.city = city
                    self.address.state = state
                    self.address.postalCode = zipcode
                }
            }
        }
    }
    
    
    func addContactWithoutAddress(contact: Contact) {
        guard let firstName = contact.firstName, let phoneNumber = contact.phoneNumber else { return }
        guard let lastName = contact.lastName else { return }
        
        let contact = CNMutableContact()
        contact.givenName = firstName.capitalized
        contact.familyName = lastName.capitalized
        contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: phoneNumber))]
        contact.note = "Added With Maralog"
        
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        try? store.execute(saveRequest)
    }
    
    
    func addToCNContacts(contact: Contact) {
        guard let firstName = contact.firstName, let phoneNumber = contact.phoneNumber else { return }
        guard let lastName = contact.lastName else { return }
        
        let contact = CNMutableContact()
        contact.givenName = firstName.capitalized
        contact.familyName = lastName.capitalized
        contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: phoneNumber))]
        contact.note = "Added With Maralog"
        
        let dateAdded = NSDateComponents()
        dateAdded.month = Calendar.current.component(.month, from: Date())
        dateAdded.year = Calendar.current.component(.year, from: Date())
        dateAdded.day = Calendar.current.component(.day, from: Date())
        let date = CNLabeledValue(label: "Date Added", value: dateAdded)
        contact.dates = [date]
        
        
        let locationMet = CNLabeledValue<CNPostalAddress>(label: "Location Added", value: address)
        contact.postalAddresses = [locationMet]
        
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        try? store.execute(saveRequest)
    }
    
    
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
    
    func allign(label: UILabel, with textField: UITextField) {
        label.frame.origin.y = textField.frame.origin.y
        label.frame.origin.x = textField.frame.origin.x
    }
    
    func detailLabelsAreInvisible() {
        self.labelOfPhoneNumber.isHidden = true
        self.labelOfFirstName.isHidden = true
        self.labelOfLastName.isHidden = true
    }
    
    func hilightEmpty(_ textField: UITextField) {
    
        UIView.animate(withDuration: 0.15, animations: {
            textField.backgroundColor = Keys.sharedInstance.errorColor
        }) { (_) in
            UIView.animate(withDuration: 0.15, animations: {
                textField.backgroundColor = .clear
            })
        }
    }
}















