import Foundation
import CoreData

extension Contact {
    
    convenience init(firstName: String, lastName: String, phoneNumber: String, timeStamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.timeStamp = timeStamp
    }
    
    var firstLetter: String {
        guard let firstName = firstName?.trimmingCharacters(in: .whitespaces) else { return "" }
        let sectionHeader = (String(firstName[firstName.index(firstName.startIndex, offsetBy: 0)]).uppercased())
        return sectionHeader
    }
    
    
    var fullName: String {
        guard let firstName = firstName?.trimmingCharacters(in: .whitespaces),
            let lastName = lastName?.trimmingCharacters(in: .whitespaces) else {
            return ""
        }
        let full = "\(firstName) \(lastName)"
        return full
    }
}




















