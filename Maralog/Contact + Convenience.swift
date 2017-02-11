//
//  Contact + Convenience.swift
//  Maralog
//
//  Created by Ilias Basha on 2/6/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import Foundation
import CoreData

extension Contact {
    
    convenience init(firstName: String, lastName: String, phoneNumber: String, timeStamp: Date = Date(), location: Location? = nil, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.timeStamp = timeStamp as NSDate
        self.location = location
    }
    
    var firstLetter: String {
        guard let firstName = firstName else { return "" }
        let sectionHeader = (String(firstName[firstName.index(firstName.startIndex, offsetBy: 0)]).uppercased())
        return sectionHeader
    }
}


extension Contact: SearchableContact {
    
    func matchesSearchTerm(with term: String) -> Bool {
        guard let fNameTerm = firstName?.lowercased().components(separatedBy: " "),
            let lNameTerm = lastName?.lowercased().components(separatedBy: " ") else { return false }

        if(fNameTerm.contains(term.lowercased()) || lNameTerm.contains(term.lowercased())) {
            return true
        } else {
            return false
        }
    }
    
}
