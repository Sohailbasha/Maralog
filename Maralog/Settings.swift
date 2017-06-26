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
    
    private static let kName = "name"
    private static let kIsOn = "isOn"
    private static let kIcon = "icon"
    private static let kDescription = "description"

    
    let name: String
    var isOn: Bool
    let icon: UIImage
    let description: String
    
    init(name: String, isOn: Bool, icon: UIImage, description: String) {
        self.name = name
        self.isOn = isOn
        self.icon = icon
        self.description = description
    }
    
    var dictionaryRep: [String: Any] {
        return[Settings.kName: name, Settings.kIsOn: isOn, Settings.kIcon: icon]
    }
    
    
    var enabled: Bool {
        return false
    }
    
    
    
    convenience init?(dictionary: [String: Any]) {
        guard let name = dictionary[Settings.kName] as? String,
            let description = dictionary[Settings.kDescription] as? String,
            let isOn = dictionary[Settings.kIsOn] as? Bool,
            let icon = dictionary[Settings.kIcon] as? UIImage else { return nil }
        self.init(name: name, isOn: isOn, icon: icon, description: description)
    }
}
