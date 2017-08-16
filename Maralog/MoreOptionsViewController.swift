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
        
        let settings = SettingsController.sharedInstance.settings
        
        groups = [nameArray, settings]
        
        self.checkSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.checkSettings()
        tableView.reloadData()
    }
    
    
    // MARK: - Properties
    
    var isAutoTextEnabled = Bool()
    
    var isLocationServicesEnabled = Bool()
    
    let section = ["Change Name", "Change Default Settings"]
    
    var groups = [[]]
    
    
    func checkSettings() {
        isAutoTextEnabled = SettingsController.sharedInstance.getTextSetting()
        isLocationServicesEnabled = SettingsController.sharedInstance.getLocationSetting()
    }
    
  
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSettingControlls" {
            if let destinationVC = segue.destination as? SettingsInfoTableViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    
                    switch indexPath.section {
                    case 0:
                        self.changeNameAlert(completion: { (newName) in
                            self.groups[indexPath.section][indexPath.row] = newName
                            self.tableView.reloadData()
                        })
                        
                    default:
                        if let setting = groups[indexPath.section][indexPath.row] as? Settings {
                            destinationVC.setting = setting
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    
}


extension MoreOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
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
                
                if (setting.isOn) {
                    cell.detailTextLabel?.text = "On"
                } else {
                    cell.detailTextLabel?.text = "Off"
                }
            }
        }
        return cell
    }
    
}

/*
extension MoreOptionsViewController: SwitchSettingsDelegate {
    
    func captureDefaultSettingFor(setting: Settings, selected: Bool) {
        SettingsController.sharedInstance.saveAsDefault(setting: setting, value: selected)
        tableView.reloadData()
    }
}
*/



