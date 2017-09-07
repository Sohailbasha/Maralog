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
        
        self.hideLabelsAndText()

        phoneNumberTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self

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
        autoTextToggled == true ? select(button: atButtonOutlet, label: autoTextLabel) : deselect(button: atButtonOutlet, label: autoTextLabel)
        locationToggled == true ? select(button: lsButtonOutlet, label: locationSaveLabel) : deselect(button: lsButtonOutlet, label: locationSaveLabel)
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
    
    // Constraints
    @IBOutlet var pNumVerticalConst: NSLayoutConstraint!
    @IBOutlet var fNameVerticalConst: NSLayoutConstraint!
    @IBOutlet var lNameVerticalConst: NSLayoutConstraint!
    
    
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
                    
                    self.swipeCard(completion: { (success, contact) in
                        if (success) {
                            if let contact = contact {
                                DispatchQueue.main.async {
                                    self.sendMessageTo(contact: contact)
                                }
                            }
                        }
                    })
                    self.resetCard()
                    self.hideLabelsAndText()
                })
                return
            }
            UIView.animate(withDuration: 0.3) {
                self.resetCard()
//                self.firstNameTextField.shake()
//                self.phoneNumberTextField.shake()
            }
        }
        
    }
    
    
    
    func swipeCard(completion: (Bool, Contact?) -> Void) {
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
        }
    }
    
    
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case atButtonOutlet:
            if autoTextToggled == false {
                autoTextToggled = true
                select(button: atButtonOutlet, label: autoTextLabel)
            } else {
                autoTextToggled = false
                deselect(button: atButtonOutlet, label: autoTextLabel)
            }
            
        case lsButtonOutlet:
            if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
                permissionsAlert(title: "Location Services Are Off", message: "Enabel Access When In Use")
            } else {
                if locationToggled == false {
                    locationToggled = true
                    getCurrentLocationForCNContact()
                    select(button: lsButtonOutlet, label: locationSaveLabel)
                } else {
                    locationToggled = false
                    deselect(button: lsButtonOutlet, label: locationSaveLabel)
                }
            }
            
        default:
            return
        }
    }
    
    
    

    // MARK: - Action

    
    func select(button: UIButton, label: UILabel) {
        let insets: CGFloat = 5
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            
            button.layer.cornerRadius = 0.5 * button.layer.bounds.height
            button.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            button.tintColor = .white
            button.backgroundColor = Keys.sharedInstance.randomColor()
            button.imageEdgeInsets = UIEdgeInsetsMake(insets, insets, insets, insets)
            
            label.transform = CGAffineTransform(translationX: 0, y: 10)
        }, completion: nil)
    }
    
    func deselect(button: UIButton, label: UILabel) {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            
            button.transform = CGAffineTransform.identity
            button.tintColor = self.colorForUnselectedUI

            button.backgroundColor = .clear
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            label.transform = CGAffineTransform.identity

        }, completion: nil)
        
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
}

extension UIView: CardViewDelegate, Fadeable {}










