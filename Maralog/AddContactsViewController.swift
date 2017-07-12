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
        
        coreLocationManager = CLLocationManager()
        coreLocationManager.delegate = self
        coreLocationManager.startUpdatingLocation()
        coreLocationManager.requestWhenInUseAuthorization()
        
        self.hideLabelsAndText()
        
        phoneNumberTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
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

        saveButton.backgroundColor = UIColor.clear
        saveButton.layer.cornerRadius = 20
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = Keys.sharedInstance.tabBarSelected.cgColor
        
        CNContactAdd.sharedInstance.checkAuthorization()
        
        
        isToggled()
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
        
        isToggled()
    }
    
    
    
    // TODO: Move Later
    func isToggled() {
        autoTextToggled = SettingsController.sharedInstance.getTextSetting()
        locationToggled = SettingsController.sharedInstance.getLocationSetting()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.hideLabelsAndText()
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
    
    var yourName: String {
        return UserController.sharedInstance.getName()
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
    
    @IBOutlet var atButtonOutlet: UIButton!
    @IBOutlet var lsButtonOutlet: UIButton!
    
    
    
    // move later
    
    var locationToggled = Bool()
    var autoTextToggled = Bool()
    
    
    
    
    // Views
    
    // Constraints
    
    @IBOutlet var pNumVerticalConst: NSLayoutConstraint!
    
    @IBOutlet var fNameVerticalConst: NSLayoutConstraint!
    
    @IBOutlet var lNameVerticalConst: NSLayoutConstraint!
    
    
    @IBAction func locationServiceButtonTapped(_ sender: UIButton) {
        if locationToggled == false {
            lsButtonOutlet.tintColor = .blue
            locationToggled = true
        } else {
            lsButtonOutlet.tintColor = .gray
            locationToggled = false
        }
    }
    
    @IBAction func autoTextButtonTapped(_ sender: UIButton) {
        if autoTextToggled == false {
            atButtonOutlet.tintColor = .blue
            autoTextToggled = true
        } else {
            atButtonOutlet.tintColor = .gray
            autoTextToggled = false
        }
    }
    
    // MARK: - Action
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespaces).capitalized, !firstName.isEmpty,
            let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespaces).capitalized,
            let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else { return }
        
        let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
        
        if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            switch (locationToggled, autoTextToggled) {
            case (true, true):
                ContactController.sharedInstance.addContact(contact: contact)
                CNContactAdd.sharedInstance.addToCNContacts(contact: contact, address: address)
                self.saveButtonAnimation()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.sendAutoTextTo(phoneNumber: phoneNumber, firstName: firstName)
                })
            case (false, false):
                ContactController.sharedInstance.addContact(contact: contact)
                CNContactAdd.sharedInstance.addContactWithoutAddress(contact: contact)
                self.saveButtonAnimation()
                
            case (true, false):
                ContactController.sharedInstance.addContact(contact: contact)
                CNContactAdd.sharedInstance.addToCNContacts(contact: contact, address: address)
                self.saveButtonAnimation()
                
            case (false, true):
                ContactController.sharedInstance.addContact(contact: contact)
                CNContactAdd.sharedInstance.addContactWithoutAddress(contact: contact)
                self.saveButtonAnimation()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.sendAutoTextTo(phoneNumber: phoneNumber, firstName: firstName)
                })
            }
        } else {
            self.permissionsAlert(title: "Unable to access Contacts",
                                  message: "Maralog requires access to your contacts in order to save new ones there. Please enabel them.")
        }
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.hideLabelsAndText()
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
    
}


// MARK: - HELPER METHODS

extension AddContactsViewController {
    
    func sendAutoTextTo(phoneNumber: String, firstName: String) {
        if(MessageSender.sharedInstance.canSendText()) {
            MessageSender.sharedInstance.recepients.append(phoneNumber)
            MessageSender.sharedInstance.textBody = "Hi \(firstName.capitalized), it's \(self.yourName)"
            let messageComposerVC = MessageSender.sharedInstance.configuredMessageComposeViewController()
            
            
            self.present(messageComposerVC, animated: true, completion: {
                self.hideLabelsAndText()
            })
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Phone unable to send messages.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
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
    
    func saveButtonAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.saveButton.backgroundColor = Keys.sharedInstance.tabBarSelected
            self.saveButton.setTitle("Saved!", for: .normal)
            self.saveButton.setTitleColor(.white, for: .normal)
            self.hideLabelsAndText()
        }) { (_) in
            self.fadeBackIn()
        }
    }
    
    func fadeBackIn() {
        UIView.animate(withDuration: 0.5, animations: {
            self.saveButton.backgroundColor = .clear
            self.saveButton.setTitle("Save", for: .normal)
            let color = Keys.sharedInstance.tabBarSelected
            self.saveButton.setTitleColor(color, for: .normal)
        }, completion: nil)
        
    }
    
    func allign(label: UILabel, with textField: UITextField) {
        label.frame.origin.y = textField.frame.origin.y
        label.frame.origin.x = textField.frame.origin.x
    }
    
    
    func hideLabelsAndText() {
        self.phoneNumberTextField.text = ""
        self.firstNameTextField.text = ""
        self.lastNameTextField.text = ""
        self.labelOfPhoneNumber.isHidden = true
        self.labelOfFirstName.isHidden = true
        self.labelOfLastName.isHidden = true
    }
}


// MARK: - TEXTFIELD DELEGATE METHODS

extension AddContactsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
        case firstNameTextField:
            self.popUp(label: labelOfFirstName, constraint: fNameVerticalConst)
        case lastNameTextField:
            self.popUp(label: labelOfLastName, constraint: lNameVerticalConst)
        case phoneNumberTextField:
            self.popUp(label: labelOfPhoneNumber, constraint: pNumVerticalConst)
        default:
            break
        }
    }
    
    
    func popUp(label: UILabel, constraint: NSLayoutConstraint) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            label.isHidden = false
            constraint.constant = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let fNameText = firstNameTextField.text else { return }
        guard let lNameText = lastNameTextField.text else { return }
        guard let pNumberText = phoneNumberTextField.text else { return }
        
        switch textField {
        case firstNameTextField:
            if fNameText.isEmpty {
                popDown(label: labelOfFirstName, constraint: fNameVerticalConst)
            }
        case lastNameTextField:
            if lNameText.isEmpty {
                popDown(label: labelOfLastName, constraint: lNameVerticalConst)
            }
        case phoneNumberTextField:
            if pNumberText.isEmpty {
                popDown(label: labelOfPhoneNumber, constraint: pNumVerticalConst)
            }
        default:
            break
        }
        
    }
    
    func popDown(label: UILabel, constraint: NSLayoutConstraint) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            constraint.constant = -14
            self.view.layoutIfNeeded()
            label.alpha = 0
        }) { (_) in
            label.alpha = 1
            label.isHidden = true
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











