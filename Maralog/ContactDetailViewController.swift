//
//  ContactDetailViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 2/7/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ContactDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
        self.setupButons()
        detailDisplayView.layer.cornerRadius = 10
    }
    
    
    // MARK: - Properties
    var contact: Contact?
    
    var usersLocation: Location? {
        return contact?.location
    }
    
    
    
    func updateViews() {
        guard let contact = self.contact,
            let firstName = contact.firstName as String?,
            let lastName = contact.lastName as String?,
            let number = contact.phoneNumber as String?,
            let timeStamp = contact.timeStamp as? Date else { return }
        
        
        let timeStampFormatted = FormattingDate.sharedInstance.formatter.string(from: timeStamp)

        fullName.text = "\(firstName) \(lastName)"
        phoneNumber.text = number
        timeMetLabel.text = ""
        locationMetLabel.text = "No location info"
    
        
        if contact.location != nil {

            if let location = contact.location {
                let coordinate = LocationController.sharedInstance.getLocationCoordinates(location: location)
                let currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                
                
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
                    if let error = error {
                        print("Reverse geocoder failed with error: \(error.localizedDescription)")
                    }
                    guard let placemarks = placemarks else {
                        return
                    }
                    if placemarks.count > 0 {
                        let pm = placemarks[0] as CLPlacemark
                        if let city = pm.locality,
                            let state = pm.administrativeArea,
                            let street = pm.thoroughfare,
                            let zipcode = pm.postalCode {
                            self.locationMetLabel.text = "met: \(street). \(city), \(state) \(zipcode)"
                            self.timeMetLabel.text = timeStampFormatted
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func callButtonTapped(_ sender: Any) {
        let callNumber: String = phoneNumber.text ?? ""
        if let phoneURL = URL(string: "tel://\(callNumber)") {
            let application: UIApplication = UIApplication.shared
            if application.canOpenURL(phoneURL) {
                application.open(phoneURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func textButtonTapped(_ sender: Any) {
        let callNumber: String = phoneNumber.text ?? ""
        if(MessageSender.sharedInstance.canSendText()) {
            MessageSender.sharedInstance.recepients.append(callNumber)
            let messageComposerVC = MessageSender.sharedInstance.configuredMessageComposeViewController()
            present(messageComposerVC, animated: true, completion: {
                MessageSender.sharedInstance.recepients.removeAll()
            })
        }
    }
    
    
    // menu actions
    
    @IBAction func editContact(_ sender: Any) {
        setupMenu()
    }
    
    @IBAction func saveMenuButtonTapped(_ sender: Any) {
        guard let firstName = editFirstNameTextField.text?.trimmingCharacters(in: .whitespaces),
            let lastName = editLastNameTextField.text?.trimmingCharacters(in: .whitespaces),
            let number = editPhoneTextField.text else {
                return }
        
        if let contact = contact {
            
            if contact.location == nil {
                ContactController.sharedInstance.update(contact: contact,
                                                        firstName: firstName.capitalized,
                                                        lastName: lastName.capitalized,
                                                        phoneNumber: number)
                
                fullName.text = "\(firstName) \(lastName)"
                phoneNumber.text = number
                
            } else {
                guard let timeStamp = contact.timeStamp as? Date else {
                    return }
                fullName.text = "\(firstName) \(lastName)"
                phoneNumber.text = number
                ContactController.sharedInstance.updateContactWithLocation(contact: contact,
                                                                           firstName: firstName.capitalized,
                                                                           lastName: lastName.capitalized,
                                                                           phoneNumber: number,
                                                                           timeStamp: timeStamp,
                                                                           location: contact.location)
            }
        }
        removeMenuView()
    }
    
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        removeMenuView()
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet var fullName: UILabel!
    @IBOutlet var phoneNumber: UILabel!
    @IBOutlet var locationMetLabel: UILabel!
    @IBOutlet var timeMetLabel: UILabel!
    
    
    @IBOutlet var editButton: UIButton!
    @IBOutlet var callButton: UIButton!
    @IBOutlet var textButton: UIButton!
    
    @IBOutlet var detailDisplayView: UIView!
    
    
    
    // edit contact view
    @IBOutlet var editMenuView: UIView!
    @IBOutlet var editPhoneTextField: UITextField!
    @IBOutlet var editFirstNameTextField: UITextField!
    @IBOutlet var editLastNameTextField: UITextField!
}



extension ContactDetailViewController {
    
    func setupButons() {
        editButton.layer.cornerRadius = 0.5 * editButton.bounds.width
        callButton.layer.cornerRadius = 0.5 * callButton.bounds.width
        textButton.layer.cornerRadius = 0.5 * textButton.bounds.width
        
    }
    
    func setupMenu() {
        editMenuView.frame.origin.x = 380
        editMenuView.center.y = self.view.center.y
        self.view.addSubview(editMenuView)
        
        UIView.animate(withDuration: 0.75) {
            self.editMenuView.center.x = self.view.center.x
        }
        editPhoneTextField.text = contact?.phoneNumber
        editFirstNameTextField.text = contact?.firstName
        editLastNameTextField.text = contact?.lastName
    }
    
    func removeMenuView() {
        UIView.animate(withDuration: 0.75, animations: {
            self.editMenuView.frame.origin.x = -400
        }) { (_) in
            self.editMenuView.removeFromSuperview()
        }
    }
    
    
}

















