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
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        let name = UserController.sharedInstance.getName()
        let nameArray = [name]
        
        
        
        settings = SettingsController.sharedInstance.settings
        
        groups = [nameArray, settings]
        
    }
    
    
    let section = ["Change Name", "Change Default Settings"]
    
    var groups = [[]]
    
    var settings: [Settings] = []
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSettingControlls" {
            if let destinationVC = segue.destination as? SettingsInfoTableViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    
                    switch indexPath.section {
                    case 0:
                        self.changeNameAlert()
                        
                    default:
                        if let setting = groups[indexPath.section][indexPath.row] as? Settings {
                            destinationVC.updateDetailWith(setting)
                        }
                    }
                }
            }
        }
        
        
    }
    
    
    // MARK: - Outlets
    
    
    @IBOutlet var tableView: UITableView!
    
    
    
    // MARK: - Actions
    
    
    
}



extension MoreOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.contentView.backgroundColor = #colorLiteral(red: 0.9514792195, green: 0.9514792195, blue: 0.9514792195, alpha: 1)
        header?.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        header?.textLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
 
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as? UITableViewHeaderFooterView
        footer?.contentView.backgroundColor = #colorLiteral(red: 0.9514792195, green: 0.9514792195, blue: 0.9514792195, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            if let name = groups[indexPath.section][indexPath.row] as? String {
                cell.textLabel?.text = " \(name)"
                cell.detailTextLabel?.text = ""
            }
           
        default:
            if let setting = groups[indexPath.section][indexPath.row] as? Settings {
                cell.textLabel?.text = setting.name
                cell.imageView?.image = setting.icon
                cell.detailTextLabel?.text = ""
            }
        }
        
        return cell
    }
    
    
    func changeNameAlert() {
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
                
            }
        })
        
        let nvmAction = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
        
        alertController.addAction(okayAction)
        alertController.addAction(nvmAction)
        self.present(alertController, animated: true, completion: {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section) {
        case 0:
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

                }
            })

            let nvmAction = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
            
            alertController.addAction(okayAction)
            alertController.addAction(nvmAction)
            self.present(alertController, animated: true, completion: { 
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            
        default:
            let segue = UIStoryboardSegue(identifier: "toSettingsControlls", source: , destination: )
            self.prepare(for: UIStoryboardSegue(), sender: self)
        }
    }
    */
    
    
    
}

//extension MoreOptionsViewController: SwitchSettingsDelegate {
//    func captureDefaultSettingFor(cell: SettingsCollectionViewCell, selected: Bool) {
//        if let setting = cell.setting, let indexPath = collectionView.indexPath(for: cell) {
//            setting.isOn = selected
//            collectionView.reloadItems(at: [indexPath])
//            SettingsController.sharedInstance.saveAsDefault(setting: setting, value: selected)
//        }
//    }
//}





