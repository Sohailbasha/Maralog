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
        
        guard let setting = self.setting else {
            return }
        
        self.updateDetailWith(setting)
        self.title = setting.name
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard let setting = self.setting else {
            return }
        self.updateDetailWith(setting)
        settingSwitch.isOn = setting.isOn
        self.tableView.reloadData()
    
    }
    
    
    
    
    
    var setting: Settings?
    
    var delegate: SwitchSettingsDelegate?
    
    var switchStatus = Bool()
    

    func updateDetailWith(_ setting: Settings) {
        imageView.image = setting.icon
        textView.text = setting.description
        settingSwitch.isOn = setting.isOn
    }
    
    func checkSettings() {
        
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
            
            self.tableView.reloadData()
        }
    }
}



protocol SwitchSettingsDelegate: class {
    
    func captureDefaultSettingFor(setting: Settings, selected: Bool)
}