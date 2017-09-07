//
//  CardViewDelegate.swift
//  Maralog
//
//  Created by Ilias Basha on 9/7/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

protocol CardViewDelegate { }
extension CardViewDelegate where Self: UIView {
    
    // Cards shadow
    func setShadow() {
        self.layer.cornerRadius = 20
        let color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
}



