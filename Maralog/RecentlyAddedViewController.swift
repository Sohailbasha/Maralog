//
//  RecentlyAddedViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 2/6/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit
import CoreData

import Contacts
import ContactsUI

class RecentlyAddedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, CNContactViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchedResultsController.delegate = self
        do { try fetchedResultsController.performFetch() }
        catch { print("Error starting fetched results controller: \(error)") }
        allContactsForDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        allContactsForDelegate()
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    
    // MARK: - Properties
    
    weak var delegate: RecentlyAddedDelegate?
    var contacts: [Contact]? {
        return fetchedResultsController.fetchedObjects
    }
    
    // MARK: - All Contacts Delegate
    func allContactsForDelegate() {
        if let contacts = fetchedResultsController.fetchedObjects {
            let numOfContacts = contacts.count
            delegate?.recentlyAddedContacts(count: numOfContacts)
        }
    }
    
    
    // MARK: - Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentlyAdded", for: indexPath) as UITableViewCell
        let contact = fetchedResultsController.object(at: indexPath)
        var dateString = ""
        
        if let timeStamp = contact.timeStamp {
            let dateAdded = FormattingDate.sharedInstance.formatter.string(from: timeStamp as Date)
            dateString = dateAdded
        }
        cell.textLabel?.text = contact.fullName
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightUltraLight)
        
        cell.detailTextLabel?.text = "added \(dateString)"
        cell.detailTextLabel?.textColor = .black
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 10, weight: UIFontWeightUltraLight)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = fetchedResultsController.object(at: indexPath)
        guard let phoneNumber = contact.phoneNumber, let firstName = contact.firstName else {
            return }
        self.showContact(phoneNumber: phoneNumber, name: firstName)
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let contact = fetchedResultsController.object(at: indexPath)
        let delete = UITableViewRowAction(style: .default, title: "Delete Contact") { (action, indexPath) in
            ContactController.sharedInstance.removeContact(contact: contact)
        }
        delete.backgroundColor = .black
        return [delete]
    }
    

    
    // MARK: - Fetched Results Controller
    
    let fetchedResultsController: NSFetchedResultsController<Contact> = {
        let threeDaysAgo = Date().addingTimeInterval(-259200) // How to make recent contacts last 3 days.
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        let predicate = NSPredicate(format: "timeStamp > %@", threeDaysAgo as CVarArg)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: CoreDataStack.context,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }()
}

// MARK: - NSFetched Results Controller Delegate Methods
extension RecentlyAddedViewController {
    
    
    // MARK: - Fetched Results Delegates
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .fade)
            allContactsForDelegate()
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            allContactsForDelegate()
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

// MARK: - Helper Methods
extension RecentlyAddedViewController {
    
    func showContact(phoneNumber: String, name: String) {
        
        let number: CNPhoneNumber = CNPhoneNumber(stringValue: phoneNumber)
        //        let number = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: phoneNumber))]
        
        
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
            let filteredContact = contacts.filter({$0.phoneNumbers.first?.value == number})
            //            let contact = contacts[0]
            let contact = filteredContact[0]
            
            let cvc = CNContactViewController(for: contact)
            cvc.delegate = self
            cvc.allowsEditing = true
            
            self.navigationController?.pushViewController(cvc, animated: true)
        } else {
            let alert = UIAlertController(title: "Error",
                                          message: "Could not find \(name) in the Contacts application. You may have deleted or modified it",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }

}

protocol RecentlyAddedDelegate: class {
    func recentlyAddedContacts(count: Int)
}



























