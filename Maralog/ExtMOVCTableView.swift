//
//  ExtMOVCTableView.swift
//  Maralog
//
//  Created by Ilias Basha on 8/16/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import Foundation
import UIKit



extension MoreOptionsViewController {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.contentView.backgroundColor = #colorLiteral(red: 0.9514792195, green: 0.9514792195, blue: 0.9514792195, alpha: 1)
        header?.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        header?.textLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as? UITableViewHeaderFooterView
        footer?.contentView.backgroundColor = #colorLiteral(red: 0.9514792195, green: 0.9514792195, blue: 0.9514792195, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    // Change Name
    
    func changeNameAlert(completion: @escaping ((String) -> Void)) {
        var nameTextField: UITextField?
        let alertController = UIAlertController(title: "Change your name",
                                                message: "Your name will appear on Auto-Text messages to newly added contacts",
                                                preferredStyle: .alert)
        
        
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "enter here"
            textField.keyboardType = .default
            nameTextField = textField
        })
        
        let okayAction = UIAlertAction(title: "Save Name", style: .default, handler: { (_) in
            if let newName = nameTextField?.text, !newName.isEmpty {
                UserController.sharedInstance.saveUserName(name: newName)
                completion(newName)
            }
        })
        
        let nvmAction = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
        
        alertController.addAction(okayAction)
        alertController.addAction(nvmAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
