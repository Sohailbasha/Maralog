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
            settingButton.imageView?.image = setting.icon
            settingButton.isSelected = setting.isOn
            
            backgroundColor = setting.isOn ? UIColor.cyan : UIColor.lightGray
        }
    }
    
    
    var delegate: SettingsButtonSelected?
    
    
    
    
    @IBOutlet var settingNameLabel: UILabel!
    @IBOutlet var settingButton: UIButton!
    
    
    @IBAction func settingButtonTapped(_ sender: UIButton) {
        
        delegate?.settingSelected(cell: self, selected: sender.isSelected)
        backgroundColor = settingButton.isSelected ? UIColor.cyan : UIColor.lightGray
    }
    
}

protocol SettingsButtonSelected: class {
    func settingSelected(cell: ACFeaturesCollectionViewCell, selected: Bool)
}





// OLD CODE


// gives the cell its initial value.
//    override var isSelected: Bool {
//        didSet {
//            if isSelected {
//                self.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
//                self.layer.cornerRadius = 10
//                self.settingIcon.tintColor = UIColor.white
//                self.settingNameLabel.textColor = UIColor.white
//            } else {
//                self.backgroundColor = UIColor.white
//                self.layer.cornerRadius = 0
//                self.settingIcon.tintColor = UIColor.black
//                self.settingNameLabel.textColor = UIColor.black
//            }
//        }
//    }






