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
        setupViews()
    }
    
    func setupButton(_ button: UIButton) {
        button.layer.borderColor = #colorLiteral(red: 0.9991653562, green: 0.5283692479, blue: 0.591578424, alpha: 1)
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 6
        button.setTitleColor(#colorLiteral(red: 0.9991653562, green: 0.5283692479, blue: 0.591578424, alpha: 1), for: .normal)
    }
    
    func setupViews() {
        card.layer.cornerRadius = 10
        
        self.setupButton(lsButtonOutlet)
        self.setupButton(atButtonOutlet)
   
        
        coreLocationManager = CLLocationManager()
        coreLocationManager.delegate = self
        coreLocationManager.startUpdatingLocation()
        coreLocationManager.requestWhenInUseAuthorization()
        
        phoneNumberTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        addButton.layer.cornerRadius = 15
        addButton.layer.shadowOpacity = 0.25
        addButton.clipsToBounds = false
        addButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        self.hideLabelsAndText()
    
        CNContactAdd.sharedInstance.checkAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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
    
    let yourName = UserController.sharedInstance.getName()
    
    var locationToggled = false
    var autoTextToggled = false
    
    let colorForSelectedUI = Keys.sharedInstance.trimColor
    let colorForUnselectedUI = Keys.sharedInstance.tabBarDefault
    
    
    
    // MARK: - Outlets
    @IBOutlet var card: UIView!
    
    // Text Fields
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    
    // Button
    
    @IBOutlet var atButtonOutlet: UIButton!
    @IBOutlet var lsButtonOutlet: UIButton!
    
    @IBOutlet var pNumLabel: UILabel!
    @IBOutlet var fNameLabel: UILabel!
    @IBOutlet var lNameLabel: UILabel!
    
    @IBOutlet var topStack: UIStackView!
    @IBOutlet var middleStack: UIStackView!
    @IBOutlet var bottomStack: UIStackView!
    
    @IBOutlet var addButton: UIButton!
    
    @IBAction func addButtonTapped(_ sender: Any) {
        addContact { (success, contact) in
            if(success) {
                DispatchQueue.main.async {
                    guard let contact = contact else { return }
                    self.sendMessageTo(contact: contact)
                }
            }
        }
    }
    
    
    func addContact(completion: (Bool, Contact?) -> Void) {
        guard let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespaces), !firstName.isEmpty else { return }
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else { return }
        guard let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        
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
    
    @IBAction func saveLocationTapped(_ sender: Any) {
        if locationToggled == false {
            lsButtonOutlet.select()
            self.getCurrentLocationForCNContact()
            locationToggled = true
        } else {
            lsButtonOutlet.deselect()
            locationToggled = false
        }
    }
    
    @IBAction func autoTextTapped(_ sender: Any) {
        if autoTextToggled == false {
            atButtonOutlet.select()
            
            autoTextToggled = true
        } else {
            atButtonOutlet.deselect()
            autoTextToggled = false
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

        fNameLabel.isHidden = true
        lNameLabel.isHidden = true
        pNumLabel.isHidden = true
    }
    
}


// MARK: - TEXTFIELD DELEGATE METHODS

extension AddContactsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case firstNameTextField:
            print("fName editing")
            UIView.animate(withDuration: 0.3, animations: {
                self.fNameLabel.isHidden = false
                self.middleStack.layoutIfNeeded()
            })
            
        case lastNameTextField:
            print("lNameEditing")
            UIView.animate(withDuration: 0.3, animations: {
                self.lNameLabel.isHidden = false
                self.bottomStack.layoutIfNeeded()
            })

        case phoneNumberTextField:
            print("pNumEditing")
            UIView.animate(withDuration: 0.3, animations: {
                self.pNumLabel.isHidden = false
                self.topStack.layoutIfNeeded()
            })
            
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
                UIView.animate(withDuration: 0.3, animations: {
                    self.fNameLabel.isHidden = true
                    self.middleStack.layoutIfNeeded()
                })
            }
        case lastNameTextField:
            if lNameText.isEmpty {
                UIView.animate(withDuration: 0.3, animations: {
                    self.lNameLabel.isHidden = true
                    self.bottomStack.layoutIfNeeded()
                })
            }
        case phoneNumberTextField:
            if pNumberText.isEmpty {
                UIView.animate(withDuration: 0.3, animations: {
                    self.pNumLabel.isHidden = true
                    self.topStack.layoutIfNeeded()
                })
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

extension UIButton: Selectable {}








