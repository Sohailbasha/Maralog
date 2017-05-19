//
//  MoreOptionsViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 5/18/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class MoreOptionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    
    
    
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var yourNameLabel: UILabel!
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SymbolsController.sharedInstance.symbols.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "symbolDictCell", for: indexPath) as? SymbolsTableViewCell
        let symbol = SymbolsController.sharedInstance.symbols[indexPath.row]
        cell?.symbol = symbol
        return cell ?? UITableViewCell()
    }

}
