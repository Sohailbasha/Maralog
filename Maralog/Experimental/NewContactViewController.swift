//
//  NewContactViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 8/10/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class NewContactViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    var numberOfContacts = 1
    
    
    @IBOutlet var tableView: UITableView!
    
    
    
    
}


extension NewContactViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfContacts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addContactCell", for: indexPath) as? NewContactTableViewCell
        
        return cell ?? UITableViewCell()
    }
    
    
}
