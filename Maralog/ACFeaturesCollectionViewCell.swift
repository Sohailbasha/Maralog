//
//  ACFeaturesCollectionViewCell.swift
//  Maralog
//
//  Created by Ilias Basha on 8/11/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class ACFeaturesCollectionViewCell: UICollectionViewCell {
    
    
    func updateWith(setting: Settings) {
        settingNameLabel.text = setting.name
        settingIcon.image = setting.icon
        
    }
    
    @IBOutlet var settingNameLabel: UILabel!
    @IBOutlet var settingIcon: UIImageView!
    @IBOutlet var isEnabledLabel: UILabel!
    
    
}
