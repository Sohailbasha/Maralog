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


class AddContactsViewController: UIViewController, CLLocationManagerDelegate, SettingsButtonSelected {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            
        } else {
            // Fallback on earlier versions
        }
        
        
        coreLocationManager = CLLocationManager()
        coreLocationManager.delegate = self
        
        coreLocationManager.startUpdatingLocation()
        coreLocationManager.requestWhenInUseAuthorization()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        
        self.hideLabelsAndText()
        
        textFieldSetUp()
        
        CNContactAdd.sharedInstance.checkAuthorization()
        checkSettings()
        cardViewShadow()
    }
    
    func cardViewShadow() {
        card.layer.cornerRadius = 10
        let color = #colorLiteral(red: 0.5817933058, green: 0.5817933058, blue: 0.5817933058, alpha: 1)
        card.layer.shadowColor = color.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        card.layer.shadowRadius = 10
        card.layer.shadowOpacity = 0.2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkSettings()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.hideLabelsAndText()
        checkSettings()
    }
    
    
    var delegate = ACFeaturesCollectionViewCell()
    
    
    func settingSelected(cell: ACFeaturesCollectionViewCell, selected: Bool) {
        if let setting = cell.setting, let cellIndexPath = collectionView.indexPath(for: cell) {
            setting.isOn = !selected
            collectionView.reloadItems(at: [cellIndexPath])
            print(!selected)
        }
    }
    
  
    func checkSettings() {
        autoTextToggled = SettingsController.sharedInstance.getTextSetting()
        locationToggled = SettingsController.sharedInstance.getLocationSetting()
    }
    
    
    // MARK: - Properties
    
    var coreLocationManager: CLLocationManager!
    var currentLocation: CLLocation?
    
    let store = CNContactStore()
    let address = CNMutablePostalAddress()
    
    let yourName = UserController.sharedInstance.getName()
    
    var locationToggled = Bool()
    var autoTextToggled = Bool()
    
    
    
    
    // MARK: - Outlets
    @IBOutlet var collectionView: UICollectionView!
    
    // Text Fields
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    
    // Labels for each Text Field
    @IBOutlet var labelOfPhoneNumber: UILabel!
    @IBOutlet var labelOfFirstName: UILabel!
    @IBOutlet var labelOfLastName: UILabel!
    
    
    // Constraints
    @IBOutlet var pNumVerticalConst: NSLayoutConstraint!
    @IBOutlet var fNameVerticalConst: NSLayoutConstraint!
    @IBOutlet var lNameVerticalConst: NSLayoutConstraint!
    
    
    
    @IBOutlet var card: UIView!
    
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
            } else if card.center.x > (view.frame.width - 75) {
                // move off to the right side
                self.saving()
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                }, completion: { (_) in
                    self.resetCard()
                })
                return
            }
            
            UIView.animate(withDuration: 0.2) {
                self.resetCard()
            }
        }
        
    }
    
    func resetCard() {
        UIView.animate(withDuration: 0.1) {
            self.card.center = self.view.center
            self.card.alpha = 1
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    // MARK: - Action
    
    func saving() {
        guard let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespaces).capitalized, !firstName.isEmpty else { return }
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else { return }
        guard let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespaces).capitalized else { return }
        
        let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
        
        if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            switch (locationToggled, autoTextToggled) {
            case (true, true):
                ContactController.sharedInstance.addContact(contact: contact)
                CNContactAdd.sharedInstance.addToCNContacts(contact: contact, address: address)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.sendAutoTextTo(phoneNumber: phoneNumber, firstName: firstName)
                })
            case (false, false):
                ContactController.sharedInstance.addContact(contact: contact)
                CNContactAdd.sharedInstance.addContactWithoutAddress(contact: contact)
            case (true, false):
                ContactController.sharedInstance.addContact(contact: contact)
                CNContactAdd.sharedInstance.addToCNContacts(contact: contact, address: address)
            case (false, true):
                ContactController.sharedInstance.addContact(contact: contact)
                CNContactAdd.sharedInstance.addContactWithoutAddress(contact: contact)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.sendAutoTextTo(phoneNumber: phoneNumber, firstName: firstName)
                })
            }
        } else {
            self.permissionsAlert(title: "Unable to access Contacts",
                                  message: "Maralog requires access to your contacts in order to save new ones there. Please enabel them.")
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
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            permissionsAlert(title: "Location Services Are Off", message: "Enabel Access When In Use")
        } else {
            let geocoder = CLGeocoder()
            guard let currentLocation = currentLocation else { return }
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
}


extension AddContactsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SettingsController.sharedInstance.settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "setting", for: indexPath) as? ACFeaturesCollectionViewCell
        let setting = SettingsController.sharedInstance.settings[indexPath.row]
        
        cell?.setting = setting
        cell?.delegate = self
        
        return cell ?? UICollectionViewCell()
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
    
    func hideLabelsAndText() {
        self.phoneNumberTextField.text = ""
        self.firstNameTextField.text = ""
        self.lastNameTextField.text = ""
        self.labelOfPhoneNumber.isHidden = true
        self.labelOfFirstName.isHidden = true
        self.labelOfLastName.isHidden = true
    }
    
}




//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let cell = collectionView.cellForItem(at: indexPath) as? ACFeaturesCollectionViewCell else { return }
//        let setting = SettingsController.sharedInstance.settings[indexPath.row]
//
//        cell.isSelected = setting.isOn
//        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
//
//        switch indexPath.row {
//        case 0:
//            locationToggled = cell.isSelected
//            print("location save \(locationToggled)")
//        default:
//            autoTextToggled = cell.isSelected
//            print("autotext: \(autoTextToggled)")
//        }
//
//    }
//
////    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
////        guard let cell = collectionView.cellForItem(at: indexPath) as? ACFeaturesCollectionViewCell else { return }
////        let setting = SettingsController.sharedInstance.settings[indexPath.row]
////
////        cell.isSelected = false
////        collectionView.deselectItem(at: indexPath, animated: false)
////
////        switch indexPath.row {
////        case 0:
////            locationToggled = cell.isSelected
////            print("location save \(locationToggled)")
////        default:
////            autoTextToggled = cell.isSelected
////            print("autotext: \(autoTextToggled)")
////        }
////    }










