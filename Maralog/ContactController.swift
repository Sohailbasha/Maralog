//
//  ContactController.swift
//  Maralog
//
//  Created by Ilias Basha on 2/6/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import Foundation
import CoreData

class ContactController {

    //MARK: - C R U D methods
    
    static let sharedInstance = ContactController()
    
    func addContact(contact: Contact) {
        saveToMemory()
    }

    func update(contact: Contact, firstName: String, lastName: String, phoneNumber: String) {
        removeContact(contact: contact)
        let _ = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
        saveToMemory()
    }
    
    func updateContactWithLocation(contact: Contact, firstName: String, lastName: String, phoneNumber: String, timeStamp: Date, location: Location?) {
        let newContact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, timeStamp: timeStamp, location: location)
        addContact(contact: newContact)
        removeContact(contact: contact)
    }
    
    func removeContact(contact: Contact) {
        if let moc = contact.managedObjectContext {
            moc.delete(contact)
        }
        saveToMemory()
    }
    
    func saveToMemory() {
        let moc = CoreDataStack.context
        do {
            try moc.save()
        } catch {
            print("unable to save: \(error)")
        }
    }
}

