//
//  ACFeaturesCollectionViewCell.swift
//  Maralog
//
//  Created by Ilias Basha on 8/11/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class ACFeaturesCollectionViewCell: UICollectionViewCell {
    
    var setting: Settings? {
        didSet {
            guard let setting = setting else { return }
            settingNameLabel.text = setting.name
            settingIcon.image = setting.icon
            change = setting.isOn
        }
    }
    
    
    // gives the cell its initial value.
    var change: Bool? {
        didSet {
            guard let change = change else { return }
            self.backgroundColor = change ? UIColor.red : UIColor.white
            self.layer.cornerRadius = change ? 10 : 0
            settingIcon.tintColor = change ? UIColor.white : UIColor.black
            settingNameLabel.textColor = change ? UIColor.white : UIColor.black
        }
    }
    
    
    
    @IBOutlet var settingNameLabel: UILabel!
    @IBOutlet var settingIcon: UIImageView!
    
    
}
