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
    @IBOutlet var saveButton: UIButton!

    @IBAction func saveButtonTapped(_ sender: Any) {
        UserController.sharedInstance.saveUserName(name: nameTextField.text)
        
        UIView.animate(withDuration: 2, animations: {
            self.saveButton.backgroundColor = .green
            self.saveButton.setTitle("Saved", for: .normal)
        }) { (_) in
            self.saveButton.backgroundColor = .white
            self.saveButton.setTitle("Save", for: .normal)
        }
    }

    @IBAction func BackButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
