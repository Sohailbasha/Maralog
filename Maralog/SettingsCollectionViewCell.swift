//
//  SettingsCollectionViewCell.swift
//  Maralog
//
//  Created by Ilias Basha on 6/30/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class SettingsCollectionViewCell: UICollectionViewCell {
    
    
    
    var setting: Settings? {
        didSet {
            guard let setting = setting else { return }
            settingIcon.image = setting.icon
            settingName.text = setting.name
            settingSwitch.isOn = setting.isOn
        }
    }
    
    
    
    var delegate: SwitchSettingsDelegate?
    
    @IBOutlet var settingSwitch: UISwitch!
    @IBOutlet var settingIcon: UIImageView!
    @IBOutlet var settingName: UILabel!
    
    @IBAction func settingSwitchTapped(_ sender: Any) {
        delegate?.captureDefaultSettingFor(cell: self, selected: settingSwitch.isOn)
    }
}


protocol SwitchSettingsDelegate: class {
    
    func captureDefaultSettingFor(cell: SettingsCollectionViewCell, selected: Bool)
    
}
