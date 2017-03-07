//
//  ContactsListViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 2/6/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit
import CoreData

class ContactsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error starting fetched results controller: \(error)")
        }
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    
    // MARK: - Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return "" }
        return sectionInfo.name
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as UITableViewCell
        let contact = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = contact.fullName
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightUltraLight)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contact = fetchedResultsController.object(at: indexPath)
            ContactController.sharedInstance.removeContact(contact: contact)
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContactDetail" {
            if let destinationVC = segue.destination as? ContactDetailViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let contact = fetchedResultsController.object(at: indexPath)
                    destinationVC.contact = contact
                }
            }
        }
    }
    
    
    // MARK: - Fetched Results Controller
    
    let fetchedResultsController: NSFetchedResultsController<Contact> = {
        
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: CoreDataStack.context,
                                          sectionNameKeyPath: "firstLetter",
                                          cacheName: nil)
    }()
}

// MARK: - NSFetched Results Controller

extension ContactsListViewController {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        default:
            break
        }
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
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .update:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
//        case .move:
//            guard let indexPath = indexPath, let newIndexPath = newIndexPath else {return}
//            tableView.moveRow(at: indexPath, to: newIndexPath)
//        case .update:
//            guard let indexPath = indexPath else {return}
//            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
