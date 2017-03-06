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
