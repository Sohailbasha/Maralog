//
//  Settings.swift
//  Maralog
//
//  Created by Ilias Basha on 5/18/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import Foundation
import UIKit

class Settings {
    
    let name: String
    let isOn: Bool
    let icon: UIImage
    
    init(name: String, isOn: Bool, icon: UIImage) {
        self.name = name
        self.isOn = isOn
        self.icon = icon
    }
    
}
