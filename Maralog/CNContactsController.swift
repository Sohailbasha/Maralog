//
//  CNContactsController.swift
//  Maralog
//
//  Created by Ilias Basha on 4/14/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import Foundation
import Contacts
import ContactsUI


class CNContactsController: CNContactViewControllerDelegate {
    
    static let sharedInstance = CNContactsController()
    
    
    func showContact(phoneNumber: String, name: String) {
        let predicate: NSPredicate = CNContact.predicateForContacts(matchingName: name)
        let descriptor = CNContactViewController.descriptorForRequiredKeys()
        let contacts: [CNContact]
        
        let store = CNContactStore()
        
        do {
            contacts = try store.unifiedContacts(matching: predicate, keysToFetch: [descriptor])
        } catch {
            contacts = []
        }
        
        if !contacts.isEmpty {
            let contact = contacts[0]
            let cvc = CNContactViewController(for: contact)
            cvc.delegate = self
            cvc.allowsEditing = false
//            self.navigationController?.pushViewController(cvc, animated: true)
        } else {
            print("no contact info available")
        }
    }
    
    
    
}
