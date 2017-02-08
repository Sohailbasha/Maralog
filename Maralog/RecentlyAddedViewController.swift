//
//  RecentlyAddedViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 2/6/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit
import CoreData

class RecentlyAddedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    
    // MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    
    var contacts: [Contact]? {
        return fetchedResultsController.fetchedObjects
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController.delegate = self
        do { try fetchedResultsController.performFetch() }
        catch { print("Error starting fetched results controller: \(error)") }
        
    }
    
    
    // MARK: - Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentlyAdded", for: indexPath) as UITableViewCell
        let contact = fetchedResultsController.fetchedObjects?[indexPath.row]
        cell.textLabel?.text = contact?.firstName
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let contact = fetchedResultsController.fetchedObjects?[indexPath.row] {
                ContactController.sharedInstance.removeContact(contact: contact)
            }
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let destinationVC = segue.destination as? ContactDetailViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let contact = fetchedResultsController.fetchedObjects?[indexPath.row]
                    destinationVC.contact = contact
                }
            }
        }
    }
    
    
    // MARK: - Fetched Results Controller
    
    let fetchedResultsController: NSFetchedResultsController<Contact> = {
        let threeDaysAgo = Date().addingTimeInterval(-259200)
        
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

extension RecentlyAddedViewController {
    
    // MARK: - Helper Method
    
    func updateData() {
        tableView.reloadData()
    }
    
    
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
