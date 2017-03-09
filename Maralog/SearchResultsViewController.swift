//
//  SearchResultsViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 3/8/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
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
    
    // MARK: - Properties
    
    var contacts: [Contact]? {
        return fetchedResultsController.fetchedObjects
    }
    
    
    let fetchedResultsController: NSFetchedResultsController<Contact> = {
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: CoreDataStack.context,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }()
    
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResult", for: indexPath)
        let contact = contacts?[indexPath.row]
        cell.textLabel?.text = contact?.fullName
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "someString contains[cd] %@", text as CVarArg)
    }
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
}


// MARK: - SearchBar Delegate

extension SearchResultsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.lowercased() else {
            return }
        let searchText = text.capitalized
        fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "someString contains[cd] %@", searchText as CVarArg)
    
    }
}


// MARK: - NSFetched Results Controller Delegate DataSource functions

extension SearchResultsViewController {
    
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
