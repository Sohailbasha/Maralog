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
            
        }
    }
    
    func updateCellInterfaceWith(color1: UIColor, color2: UIColor) {
        self.backgroundColor = color1
        settingIcon.tintColor = color2
        settingNameLabel.textColor = color2
    }
    
    @IBOutlet var settingNameLabel: UILabel!
    @IBOutlet var settingIcon: UIImageView!
    
    
}
