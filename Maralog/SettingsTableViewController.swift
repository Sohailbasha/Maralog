//
//  SettingsTableViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 3/15/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = UserController.sharedInstance.getName()
    }

    

    @IBOutlet var nameTextField: UITextField!

    @IBAction func saveButtonTapped(_ sender: Any) {
    }

}
