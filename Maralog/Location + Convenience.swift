//
//  Location + Convenience.swift
//  Maralog
//
//  Created by Ilias Basha on 2/7/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import Foundation
import CoreData

extension Location {
    convenience init(latitude: Double, longitude: Double, name: String, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
    }
}
