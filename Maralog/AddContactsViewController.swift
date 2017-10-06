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
        
        card.setShadow()
        
        coreLocationManager = CLLocationManager()
        coreLocationManager.delegate = self
        
        coreLocationManager.startUpdatingLocation()
        coreLocationManager.requestWhenInUseAuthorization()
        
        
        phoneNumberTextField.layer.cornerRadius = 20
        firstNameTextField.layer.cornerRadius = 20
        lastNameTextField.layer.cornerRadius = 20
        
        phoneNumberTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        self.hideLabelsAndText()
        
        CNContactAdd.sharedInstance.checkAuthorization()
        checkSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkSettings()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.hideLabelsAndText()
    }
    
    func checkSettings() {
        autoTextToggled = SettingsController.sharedInstance.getTextSetting()
        locationToggled = SettingsController.sharedInstance.getLocationSetting()
        
        if (autoTextToggled) {
            atButtonOutlet.customSelect {}
            autoTextLabel.fadeOut()
            autoTextLabel.fadeIn()
            autoTextLabel.text = "On"
        } else {
            atButtonOutlet.customDeselect()
            autoTextLabel.fadeOut()
            autoTextLabel.fadeIn()
            autoTextLabel.text = "Auto Text"
        }
        
        if (locationToggled) {
            
            lsButtonOutlet.customSelect {
                self.getCurrentLocationForCNContact()
            }
            locationSaveLabel.text = "On"
        } else {
            lsButtonOutlet.customDeselect()
            locationSaveLabel.text = "Location Save"
        }
    }
    
    
    // MARK: - Properties
    
    var coreLocationManager: CLLocationManager!
    var currentLocation: CLLocation?
    
    let store = CNContactStore()
    let address = CNMutablePostalAddress()
    
    let yourName = UserController.sharedInstance.getName()
    
    var locationToggled = Bool()
    var autoTextToggled = Bool()
    
    let colorForSelectedUI = Keys.sharedInstance.trimColor
    let colorForUnselectedUI = Keys.sharedInstance.tabBarDefault
    
    
    
    // MARK: - Outlets
    @IBOutlet var card: UIView!
    
    // Text Fields
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    
    // Labels for each Text Field
    @IBOutlet var labelOfPhoneNumber: UILabel!
    @IBOutlet var labelOfFirstName: UILabel!
    @IBOutlet var labelOfLastName: UILabel!
    
    // Labels for features
    @IBOutlet var locationSaveLabel: UILabel!
    @IBOutlet var autoTextLabel: UILabel!
    
    
    // Button
    
    @IBOutlet var atButtonOutlet: UIButton!
    @IBOutlet var lsButtonOutlet: UIButton!
    
    
    func resetCard() {
        UIView.animate(withDuration: 0.1) {
            self.card.center = self.view.center
            self.card.alpha = 1
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        guard let card = sender.view else { return }
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        let scale = min(100 / abs(xFromCenter), 1)
        
        if xFromCenter > 0 {
            // do something
            
            
        } else {
            // do something
        }
        
        card.center = (CGPoint(x: view.center.x + point.x, y: view.center.y))
        card.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        
        if sender.state == UIGestureRecognizerState.ended {
            if card.center.x < 75 {
                // move off to the left side of the screen
                UIView.animate(withDuration: 0.3, animations: {
                    self.hideLabelsAndText()
                }, completion: { (_) in
                    self.resetCard()
                })
                return
            } else if card.center.x > (view.frame.width - 75) && firstNameTextField.text?.isEmpty == false && phoneNumberTextField.text?.isEmpty == false {
                // move off to the right side
                
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                }, completion: { (_) in
                    
                    self.swipeCardRight(completion: { (success, contact) in
                        if (success) {
                            if let contact = contact {
                                DispatchQueue.main.async {
                                    self.sendMessageTo(contact: contact)
                                }
                            }
                        }
                        
                    })
                    
                    self.resetCard()
//                    self.hideLabelsAndText()
                })
                return
            }
            UIView.animate(withDuration: 0.3) {
                self.resetCard()
                
            }
        }
        
    }
    
    
    
    func swipeCardRight(completion: (Bool, Contact?) -> Void) {
        guard let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespaces).capitalized, !firstName.isEmpty else { return }
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else { return }
        guard let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespaces).capitalized else { return }
        
        let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
        
        if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            switch (locationToggled, autoTextToggled) {
            case (true, true):
                ContactController.sharedInstance.addContact(contact: contact)
                CNContactAdd.sharedInstance.addToCNContacts(contact: contact, address: address)
                completion(true, contact)
            case (false, false):
                ContactController.sharedInstance.addContact(contact: contact)
                CNContactAdd.sharedInstance.addContactWithoutAddress(contact: contact)
                completion(false, nil)
            case (true, false):
                ContactController.sharedInstance.addContact(contact: contact)
                CNContactAdd.sharedInstance.addToCNContacts(contact: contact, address: address)
                completion(false, nil)
            case (false, true):
                ContactController.sharedInstance.addContact(contact: contact)
                CNContactAdd.sharedInstance.addContactWithoutAddress(contact: contact)
                completion(true, contact)
            }
            hideLabelsAndText()
        } else {
            permissionsAlert(title: "Access To Contacts Are Disabled ", message: "Must Enable To Save")
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case atButtonOutlet:
            if autoTextToggled == false {
                autoTextToggled = true
                atButtonOutlet.customSelect {}
                autoTextLabel.text = "On"
            } else {
                autoTextToggled = false
                atButtonOutlet.customDeselect()
                autoTextLabel.text = "Auto Text"
            }
        case lsButtonOutlet:
            if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
                permissionsAlert(title: "Location Services Are Disabled", message: "Enable Access To Use This Feature")
            } else {
                if locationToggled == false {
                    locationToggled = true
                    getCurrentLocationForCNContact()
                    lsButtonOutlet.customSelect(completion: {
                        self.getCurrentLocationForCNContact()
                    })
                    locationSaveLabel.text = "On"
                } else {
                    locationToggled = false
                    lsButtonOutlet.customDeselect()
                    locationSaveLabel.text = "Location Save"
                }
            }
            
        default:
            return
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
        //        self.getCurrentLocationForCNContact()
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
                    
                    if let city = pm.locality {
                        self.address.city = city
                    }
                    
                    if let state = pm.administrativeArea {
                        self.address.state = state
                    }
                    
                    if let zipcode = pm.postalCode {
                        self.address.postalCode = zipcode
                    }
                    
                    var streetString = ""
                    
                    if let streetNumber = pm.subThoroughfare {
                        streetString += "\(streetNumber) "
                    }
                    
                    if let street = pm.thoroughfare {
                        streetString += street
                    }
                    
                    self.address.street = streetString
                }
            }
        }
    }
}


// MARK: - HELPER METHODS

extension AddContactsViewController {
    
    func sendMessageTo(contact: Contact) {
        guard let phoneNumber = contact.phoneNumber else { return }
        guard let firstName = contact.firstName else { return }
        
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
    
    func hideLabelsAndText() {
        self.phoneNumberTextField.text = ""
        self.firstNameTextField.text = ""
        self.lastNameTextField.text = ""
        self.labelOfPhoneNumber.fadeOut()
        self.labelOfFirstName.fadeOut()
        self.labelOfLastName.fadeOut()
    }
    
}


// MARK: - TEXTFIELD DELEGATE METHODS

extension AddContactsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case firstNameTextField:
            labelOfFirstName.fadeIn()
            
        case lastNameTextField:
            labelOfLastName.fadeIn()
            
        case phoneNumberTextField:
            labelOfPhoneNumber.fadeIn()
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let fNameText = firstNameTextField.text else { return }
        guard let lNameText = lastNameTextField.text else { return }
        guard let pNumberText = phoneNumberTextField.text else { return }
        
        switch textField {
        case firstNameTextField:
            if fNameText.isEmpty {
                labelOfFirstName.fadeOut()
            }
        case lastNameTextField:
            if lNameText.isEmpty {
                labelOfLastName.fadeOut()
            }
        case phoneNumberTextField:
            if pNumberText.isEmpty {
                labelOfPhoneNumber.fadeOut()
            }
        default:
            break
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextField {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = (newString as NSString).components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne {
                formattedString.append("1 ")
                index += 1
            }
            if (length - index) > 3 {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("(%@)", areaCode)
                index += 3
            }
            if length - index > 3 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
            
        } else {
            return true
        }
        
    }
}

extension UIView: CardViewDelegate, Fadeable {}
extension UIButton: Selectable {}








