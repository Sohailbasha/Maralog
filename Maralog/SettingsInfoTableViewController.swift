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
        
        guard let setting = self.setting else { return }
        self.updateDetailWith(setting)
        self.title = setting.name
    }
    
    
    var setting: Settings?
    var delegate: SwitchSettingsDelegate?
    

    func updateDetailWith(_ setting: Settings) {
        imageView.image = setting.icon
        textView.text = setting.description
        settingSwitch.isOn = setting.isOn
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var settingSwitch: UISwitch!
    
    
    
    // MARK: - Actions
    
    @IBAction func switchTapped(_ sender: Any) {
        if let setting = self.setting {
            delegate?.captureDefaultSettingFor(setting: setting, selected: settingSwitch.isOn)
        }
    }
}



protocol SwitchSettingsDelegate: class {
    
    func captureDefaultSettingFor(setting: Settings, selected: Bool)
}
