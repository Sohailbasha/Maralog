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
    
    func updateCellContents() {
        if let setting = setting {
            if setting.isOn == true {
                UIView.animate(withDuration: 0.3, animations: {
                    self.layer.cornerRadius = 10
                    self.changeBackground(color1: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), color2: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.layer.cornerRadius = 0
                    self.changeBackground(color1: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), color2: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                })
            }
        }
    }
    
    
    func changeBackground(color1: UIColor, color2: UIColor) {
        self.backgroundColor = color1
        settingIcon.tintColor = color2
        settingNameLabel.textColor = color2
    }
    
    @IBOutlet var settingNameLabel: UILabel!
    @IBOutlet var settingIcon: UIImageView!
    
    
}
