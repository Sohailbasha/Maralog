//
//  File.swift
//  Maralog
//
//  Created by Ilias Basha on 8/16/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import Foundation
import  UIKit
import Contacts

// CARD Functions
extension AddContactsViewController {
    
    
    // Moving the card back to its original position
    
    func resetCard() {
        UIView.animate(withDuration: 0.1) {
            self.card.center = self.view.center
            self.card.alpha = 1
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    
    // Cards shadow
    
    func cardViewShadow() {
        card.layer.cornerRadius = 10
        let color = #colorLiteral(red: 0.5817933058, green: 0.5817933058, blue: 0.5817933058, alpha: 1)
        card.layer.shadowColor = color.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        card.layer.shadowRadius = 10
        card.layer.shadowOpacity = 0.2
    }
    
    
    // Saving the information on the card
    
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
