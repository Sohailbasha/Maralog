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
    
    // Mock Data
    
    var mockData: [Contact] {
        let john = Contact(firstName: "John", lastName: "Doe", phoneNumber: "9999999999")
        let tammy = Contact(firstName: "Tammy", lastName: "Pyle", phoneNumber: "5405405400")
        let daquan = Contact(firstName: "Daquan", lastName: "Dalante", phoneNumber: "2029996464")
        return [john, tammy, daquan]
    }
    
    static let sharedInstance = ContactController()
    
    
    var contacts: [Contact] = []
    
    
    func addContact(contact: Contact) {
        saveToMemory()
    }
    
    
    func removeContact(contact: Contact) {
        if let moc = contact.managedObjectContext {
            moc.delete(contact)
        }
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
