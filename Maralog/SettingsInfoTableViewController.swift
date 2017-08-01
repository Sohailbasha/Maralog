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
        
    }
    


    func updateDetailWith(_ setting: Settings) {
    
            imageView.image = setting.icon
            textView.text = setting.description

    
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var settingSwitch: UISwitch!
    
    
    
    // MARK: - Actions
    
    @IBAction func switchTapped(_ sender: Any) {
        print("Hello World")
    }
}
