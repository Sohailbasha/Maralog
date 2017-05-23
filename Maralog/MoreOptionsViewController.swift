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
        self.yourNameLabel.text = "your name: \(name)"
        
        self.changeDesignsFor(buttons: [saveNameButton, watchWalkthroughButton])
        nameChangeTextField.layer.borderColor = Keys.sharedInstance.maralogRed.cgColor
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
            self.saveNameButton.setTitle("saved!", for: .normal)
            self.nameChangeTextField.text = ""
            self.yourNameLabel.text = "your name: \(UserController.sharedInstance.getName())"
        }) { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                let color = Keys.sharedInstance.mainColor
                self.saveNameButton.backgroundColor = .clear
                self.saveNameButton.setTitleColor(color, for: .normal)
                self.saveNameButton.setTitle("save", for: .normal)
            })
        }
    }
    
    @IBAction func watchAgainTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInVC") as? SignInViewController else { return }
        self.present(signInVC, animated: true, completion: nil)
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
            let color = Keys.sharedInstance.maralogRed
            button.backgroundColor = .clear
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 0.5
            button.layer.borderColor = color.cgColor
            button.setTitleColor(color, for: .normal)
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



