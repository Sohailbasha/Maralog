//
//  SymbolsTableViewCell.swift
//  Maralog
//
//  Created by Ilias Basha on 5/18/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class SymbolsTableViewCell: UITableViewCell {

    var symbol: Symbols? {
        didSet {
            guard let symbol = symbol else { return }
            iconImage.image = symbol.icon
            iconImage.tintColor = Keys.sharedInstance.mainColor
            descriptionForSymbol.text = symbol.description
        }
    }
    
    @IBOutlet var descriptionForSymbol: UITextView!
    @IBOutlet var iconImage: UIImageView!
    
}
