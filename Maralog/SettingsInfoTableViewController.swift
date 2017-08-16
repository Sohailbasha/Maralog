//
//  SettingsInfoTableViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 8/1/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit
import Foundation

class SettingsInfoTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let setting = self.setting {
            self.updateDetailWith(setting)
            self.title = setting.name
        }
    }
    
    
    // MARK: - Properties
    
    var setting: Settings?
    
    var switchStatus = Bool()
    
    
    func updateDetailWith(_ setting: Settings) {
        imageView.image = setting.icon
        textView.text = setting.description
        
        
        switch setting.name {
        case SettingsController.sharedInstance.textingSettingName:
            settingSwitch.isOn = SettingsController.sharedInstance.getTextSetting()
        case SettingsController.sharedInstance.locationSettingName:
            settingSwitch.isOn = SettingsController.sharedInstance.getLocationSetting()
        default:
            return
        }
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var settingSwitch: UISwitch!
    
    
    
    // MARK: - Actions
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        if let setting = self.setting {
            setting.isOn = sender.isOn
            SettingsController.sharedInstance.saveAsDefault(setting: setting, value: sender.isOn)
        }
    }
}


