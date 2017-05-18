//
//  SettingsTableViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 3/15/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UITextFieldDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = yourName
    }

    
    let yourName: String = UserController.sharedInstance.getName()
    
    // MARK: - Outlets

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var saveButton: UIButton!

    
    // MARK: - Actions 
    
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

    
    
    
    // MARK: - TextField Delegate Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
