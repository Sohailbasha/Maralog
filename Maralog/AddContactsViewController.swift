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
    
    
    let contactSavedLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = Keys.sharedInstance.barColor
        
        self.viewForContactDetails.center.x = self.view.center.x
        
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
        
        if (isLocationDefaultOn) {
            locationServicesSwitch.isOn = true
            locationIcon.tintColor = Keys.sharedInstance.trimColor
        } else {
            locationServicesSwitch.isOn = false
            locationIcon.tintColor = .lightGray
        }
        
        if (isAutoTextDefaultOn) {
            autoTextSwitch.isOn = true
            autoTextIcon.tintColor = Keys.sharedInstance.trimColor
            
        } else {
            autoTextSwitch.isOn = false
            autoTextIcon.tintColor = .lightGray
        }
        
        locationServicesSwitch.onTintColor = Keys.sharedInstance.switchActivatedColor
        autoTextSwitch.onTintColor = Keys.sharedInstance.switchActivatedColor
        
        contactSavedLabel.text = "contact saved"
        contactSavedLabel.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightThin)
        contactSavedLabel.textColor = .lightGray
        contactSavedLabel.alpha = 0.95
        contactSavedLabel.frame = CGRect(x: 0, y: (self.view.frame.height / 4), width: 280, height: 50)
        contactSavedLabel.textAlignment = .center
        contactSavedLabel.center = viewForContactDetails.center

        CNContactAdd.sharedInstance.checkAuthorization()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if isLocationDefaultOn == true {
            locationServicesSwitch.isOn = true
            locationIcon.tintColor = Keys.sharedInstance.trimColor
        } else {
            locationServicesSwitch.isOn = false
            locationIcon.tintColor = .lightGray
        }
        
        if isAutoTextDefaultOn == true {
            autoTextSwitch.isOn = true
            autoTextIcon.tintColor = Keys.sharedInstance.trimColor
        } else {
            autoTextSwitch.isOn = false
            autoTextIcon.tintColor = .lightGray
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        phoneNumberTextField.text = ""
        self.detailLabelsAreInvisible()
    }
    
    
    // MARK: - Properties
    
    var coreLocationManager: CLLocationManager!
    var currentLocation: CLLocation?
    
    
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
    
    @IBOutlet var locationServicesSwitch: UISwitch!
    @IBOutlet var autoTextSwitch: UISwitch!
    
    
    // Icons
    @IBOutlet var locationIcon: UIImageView!
    @IBOutlet var autoTextIcon: UIImageView!
    
    // Button
    @IBOutlet var saveButton: UIButton!
    
    // Views
    @IBOutlet var viewForContactDetails: UIView!
    
    
    
    // MARK: - Action
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespaces).capitalized, !firstName.isEmpty,
            let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespaces).capitalized,
            let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else { return }
        
        let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
        
        if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            switch (locationServicesSwitch.isOn, autoTextSwitch.isOn) {
            case (true, true):
                ContactController.sharedInstance.addContact(contact: contact)
                CNContactAdd.sharedInstance.addToCNContacts(contact: contact, address: address)
                sendAutoTextTo(phoneNumber: phoneNumber, firstName: firstName)
                
            case (false, false):
                ContactController.sharedInstance.addContact(contact: contact)
                CNContactAdd.sharedInstance.addContactWithoutAddress(contact: contact)
                DispatchQueue.main.async {
                    self.animateViewForDetails()
                }
                
            case (true, false):
                ContactController.sharedInstance.addContact(contact: contact)
                CNContactAdd.sharedInstance.addToCNContacts(contact: contact, address: address)
                DispatchQueue.main.async {
                    self.animateViewForDetails()
                }
                
            case (false, true):
                ContactController.sharedInstance.addContact(contact: contact)
                CNContactAdd.sharedInstance.addContactWithoutAddress(contact: contact)
                sendAutoTextTo(phoneNumber: phoneNumber, firstName: firstName)
            }
        } else {
            self.permissionsAlert(title: "Unable to access Contacts", message: "Maralog requires access to your contacts in order to save new ones there. Please enabel them.")
        }
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        phoneNumberTextField.text = ""
        firstNameTextField.text = ""
        lastNameTextField.text = ""
    }
    
    
    @IBAction func locationSwitchEnabled(_ sender: Any) {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationServicesSwitch.setOn(false, animated: true)
            permissionsAlert(title: "Location Services Are Off", message: "Enabel access to save a location")
        }
        
        switch locationServicesSwitch.isOn {
        case true:
            locationIcon.tintColor = Keys.sharedInstance.trimColor
            getCurrentLocationForCNContact()
            
        default:
            locationIcon.tintColor = .lightGray
        }
    }
    
    
    @IBAction func autoTextSwitchEnabled(_ sender: Any) {
        switch autoTextSwitch.isOn {
        case true:
            autoTextIcon.tintColor = Keys.sharedInstance.trimColor
            
        default:
            autoTextIcon.tintColor = .lightGray
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
        }
        coreLocationManager.stopUpdatingLocation()
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
            messageComposerVC.modalPresentationCapturesStatusBarAppearance = true
            DispatchQueue.main.async {
                self.present(messageComposerVC, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Phone unable to send messages.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    func getCurrentLocationForCNContact() {
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
    
    
    func animateViewForDetails() {
        
        self.view.addSubview(self.contactSavedLabel)
        self.view.sendSubview(toBack: self.contactSavedLabel)
        
        UIView.animate(withDuration: 1, animations: {
            
            self.viewForContactDetails.frame.origin.x = self.viewForContactDetails.frame.width + 18
            self.viewForContactDetails.alpha = 0
            
        }) { (_) in
            self.detailLabelsAreInvisible()
            self.phoneNumberTextField.text = ""
            self.firstNameTextField.text = ""
            self.lastNameTextField.text = ""
            self.viewForContactDetails.center.x = self.view.center.x
            UIView.animate(withDuration: 0.75, animations: {
                self.contactSavedLabel.removeFromSuperview()
                self.viewForContactDetails.alpha = 1
            })
        }
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











