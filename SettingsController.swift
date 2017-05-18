//
//  SettingsController.swift
//  Maralog
//
//  Created by Ilias Basha on 5/18/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import Foundation
import UIKit

class SettingsController {
    
    static let sharedInstance = SettingsController()
    
    var settings: [Settings] = []
    
    
    init() {
        let locationSetting: Settings = Settings(name: "Location Services", isOn: false, icon: #imageLiteral(resourceName: "locationServices"))
        let autoTextSetting: Settings = Settings(name: "Autotext", isOn: false, icon: #imageLiteral(resourceName: "autoMessage"))
        
        settings = [locationSetting, autoTextSetting]
    }
}
