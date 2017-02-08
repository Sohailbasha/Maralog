//
//  ContactDetailViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 2/7/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    var contact: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let contact = self.contact {
            self.updateWithContact(contact: contact)
        }
    }
    
    
    func updateWithContact(contact: Contact) {
        guard let firstName = contact.firstName,
            let lastName = contact.lastName,
            let number = contact.phoneNumber,
            let timeStamp = contact.timeStamp else { return }
        
        
        
        fullName.text = "\(firstName) \(lastName)"
        phoneNumber.text = number
        timeMetLabel.text = "added \(formatter.string(from: timeStamp as Date))"
    }
    
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter
    } ()

    

    // MARK: - Outlets 
    
    @IBOutlet var fullName: UILabel!
    @IBOutlet var phoneNumber: UILabel!
    @IBOutlet var locationMetLabel: UILabel!
    @IBOutlet var timeMetLabel: UILabel!
}
