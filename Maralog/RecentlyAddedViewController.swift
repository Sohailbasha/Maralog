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
    
    let noContactsLabel: UILabel = {
        let label = UILabel()
        label.text = "You have no new contacts"
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightRegular)
        label.textColor = Keys.sharedInstance.mainColor
        label.frame = CGRect(x: 100, y: 100, width: 300, height: 150)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.alpha = 0.8
        return label
    }()
    
    var contactsIsEmpty: Bool? {
        return fetchedResultsController.fetchedObjects?.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchedResultsController.delegate = self
        do { try fetchedResultsController.performFetch() }
        catch { print("Error starting fetched results controller: \(error)") }
        
        
        fetchedResultsToDelete.delegate = self
        do { try fetchedResultsToDelete.performFetch() }
        catch {print("Error starting fetched results controller: \(error)")}
        
        noNewContactslabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if UserController.sharedInstance.didrecievePopUp() == false {
            let recentlyAddedAlert = UIAlertController(title: "Recently Added List", message: "- These are the contacts which you've added through Maralog in the past 3 days. \n \n - To delete contact, swipe left on their name.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Got it.", style: .default, handler: { (_) in
                let popUp = true
                UserController.sharedInstance.recieve(popUp: popUp)
            })
            recentlyAddedAlert.addAction(action)
            self.parent?.present(recentlyAddedAlert, animated: true, completion: nil)
        }
        noNewContactslabel()
        removeOldContactsFromApp()
    }
    
    
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    
    // MARK: - Properties
    
    weak var delegate: RecentlyAddedDelegate?
    var contacts: [Contact]? {
        return fetchedResultsController.fetchedObjects
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
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightRegular)
        
        cell.detailTextLabel?.text = "added \(dateString)"
        cell.detailTextLabel?.textColor = .black
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin)
        
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = fetchedResultsController.object(at: indexPath)
        
        self.showDetailsFor(contact)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let contact = fetchedResultsController.object(at: indexPath)
        let delete = UITableViewRowAction(style: .default, title: "Delete Contact") { (action, indexPath) in
            ContactController.sharedInstance.removeContact(contact: contact)
        }
        delete.backgroundColor = .black
        return [delete]
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightSemibold)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        return "Added in the last 3 days. Swipe left to delete."
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
    
    
    
    let fetchedResultsToDelete: NSFetchedResultsController<Contact> = {
        let threeDaysAgo = Date().addingTimeInterval(-259200) // How to make recent contacts last 3 days.
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        let predicate = NSPredicate(format: "timeStamp < %@", threeDaysAgo as CVarArg)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: CoreDataStack.context,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }()
    
    
    func removeOldContactsFromApp() {
        guard let oldContacts = fetchedResultsToDelete.fetchedObjects else { return }
        for i in oldContacts {
            ContactController.sharedInstance.removeContact(contact: i)
        }
    }
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
            
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
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
    
    func showDetailsFor(_ contact: Contact) {
        guard let name = contact.firstName, let phoneNumber = contact.phoneNumber else { return }
        
        let number: CNPhoneNumber = CNPhoneNumber(stringValue: phoneNumber)
        
        
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
            let contact = filteredContact[0]
            
            let cvc = CNContactViewController(for: contact)
            cvc.delegate = self
            cvc.contactStore = store
            cvc.allowsEditing = false
            self.navigationController?.pushViewController(cvc, animated: true)
        } else {
            let alert = UIAlertController(title: "Error",
                                          message: "Could not find \(name) in the Contacts application. You may have deleted or modified it.",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func noNewContactslabel() {
        
        noContactsLabel.center.x = self.view.center.x
        contactsIsEmpty == true ? self.view.addSubview(noContactsLabel) : noContactsLabel.removeFromSuperview()
    }
}


protocol RecentlyAddedDelegate: class {
    func recentlyAddedContacts(count: Int)
}



























