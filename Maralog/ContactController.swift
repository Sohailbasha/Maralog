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
    
    func add(location: Location, with contact: Contact) {
        saveToMemory()
    }
    
    func update(contact: Contact, firstName: String, lastName: String, phoneNumber: String) {
        contact.firstName = firstName
        contact.lastName = lastName
        contact.phoneNumber = phoneNumber
        saveToMemory()
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

