//
//  CNContactAdd.swift
//  Maralog
//
//  Created by Ilias Basha on 5/28/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import Foundation
import Contacts
import UIKit

class CNContactAdd {
    
    static let sharedInstance = CNContactAdd()
    
    let calendar = Calendar.current
//    let store = CNContactStore()
    
    
    func checkAuthorization() {
        let store = CNContactStore()

        if CNContactStore.authorizationStatus(for: .contacts) != .authorized {
            store.requestAccess(for: .contacts, completionHandler: { (success, error) in
                if (success) {
                    return
                }
            })
        }
    }
    
    
    func addContactWithoutAddress(contact: Contact) {
        let store = CNContactStore()

        guard let firstName = contact.firstName, let phoneNumber = contact.phoneNumber else { return }
        guard let lastName = contact.lastName else { return }

        
        let contact = CNMutableContact()
        contact.givenName = firstName.capitalized
        contact.familyName = lastName.capitalized
        contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: phoneNumber))]
        contact.note = "Added With Maralog"
        
        
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        try? store.execute(saveRequest)
    }
    
    
    func addToCNContacts(contact: Contact, address: CNMutablePostalAddress) {
        let store = CNContactStore()

        guard let firstName = contact.firstName, let phoneNumber = contact.phoneNumber else { return }
        guard let lastName = contact.lastName, let timeStamp = contact.timeStamp else { return }
        
        
        let hour = calendar.component(.hour, from: timeStamp as Date)
        let minutes = calendar.component(.minute, from: timeStamp as Date)
        
        
        let contact = CNMutableContact()
        contact.givenName = firstName.capitalized
        contact.familyName = lastName.capitalized
        contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: phoneNumber))]
        contact.note = "Added With Maralog. \nOn \(hour):\(minutes)"
        
        
        let dateAdded = NSDateComponents()
        dateAdded.month = Calendar.current.component(.month, from: Date())
        dateAdded.year = Calendar.current.component(.year, from: Date())
        dateAdded.day = Calendar.current.component(.day, from: Date())
        let date = CNLabeledValue(label: "Date Added", value: dateAdded)
        
        
        contact.dates = [date]
        
        
        let locationMet = CNLabeledValue<CNPostalAddress>(label: "Location Added", value: address)
        contact.postalAddresses = [locationMet]
        

        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        
        
        do {try? store.execute(saveRequest)}
        
    }
 
    
}
