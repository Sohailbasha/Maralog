//
//  UserDefaultsTableViewCell.swift
//  Maralog
//
//  Created by Ilias Basha on 5/18/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class UserDefaultsTableViewCell: UITableViewCell {


    
    
    var setting: Settings? {
        didSet {
            guard let setting = setting else { return }
            settingsLabel.text = setting.name
            settingsImage.image = setting.icon
            settingsSwitch.isOn = setting.isOn
        }
        
    }
    
    var delegate: settingsTableViewDelegate?
    
    @IBOutlet var settingsImage: UIImageView!
    @IBOutlet var settingsLabel: UILabel!
    @IBOutlet var settingsSwitch: UISwitch!
    
}

protocol settingsTableViewDelegate: class {
     func settingValueChanged(cell: UserDefaultsTableViewCell, selected: Bool)
}
