//
//  MoreOptionsViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 5/18/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class MoreOptionsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let name = UserController.sharedInstance.getName()
        self.yourNameLabel.text = "Your Name: \(name)"
        
        self.changeDesignsFor(buttons: [saveNameButton, watchWalkthroughButton])
        
        nameChangeTextField.delegate = self
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var yourNameLabel: UILabel!
    
    @IBOutlet var nameChangeTextField: UITextField!
    
    @IBOutlet var saveNameButton: UIButton!
    
    @IBOutlet var watchWalkthroughButton: UIButton!
    
    
    
    // MARK: - Actions
    @IBAction func saveNameButtonTapped(_ sender: Any) {
        let color = Keys.sharedInstance.confirmColor
        UserController.sharedInstance.saveUserName(name: nameChangeTextField.text)
        UIView.animate(withDuration: 1, animations: {
            self.saveNameButton.backgroundColor = color
            self.saveNameButton.setTitleColor(.white, for: .normal)
            self.saveNameButton.setTitle("Saved!", for: .normal)
        }) { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                self.saveNameButton.backgroundColor = .clear
                self.saveNameButton.setTitleColor(.black, for: .normal)
                self.saveNameButton.setTitle("Save", for: .normal)
            })
        }
    }
}


extension MoreOptionsViewController: UITableViewDataSource, UITableViewDelegate {
    
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


extension MoreOptionsViewController {
    
    func changeDesignsFor(buttons: [UIButton]) {
        for button in buttons {
            button.backgroundColor = .clear
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.black.cgColor
            
            button.setTitleColor(.black, for: .normal)
        }
    }
}

extension MoreOptionsViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



