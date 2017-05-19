//
//  DefaultsViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 5/18/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class DefaultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @IBOutlet var tableView: UITableView!
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsController.sharedInstance.settings.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultsCell", for: indexPath) as? UserDefaultsTableViewCell
        let setting = SettingsController.sharedInstance.settings[indexPath.row]
        cell?.setting = setting
        cell?.delegate = self
        return cell ?? UITableViewCell()
    }
    
}


extension DefaultsViewController: settingsTableViewDelegate {
    
    func settingValueChanged(cell: UserDefaultsTableViewCell, selected: Bool) {
        guard let setting = cell.setting, let cellIndexPath = tableView.indexPath(for: cell) else { return }
        setting.isOn = selected
        tableView.reloadRows(at: [cellIndexPath], with: .fade)
    }
    
}
