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
    
    private static let settingsControllerKey = "settings"
    static let sharedInstance = SettingsController()
    
    var settings: [Settings] = []
    
    let locationSettingName = "Location Services"
    let textingSettingName = "Autotext"
    
    let locationKey = "locationKey"
    let textKey = "textKey"
    
    init() {
        let locationIsOn = getLocationSetting()
        let textIsOn = getTextSetting()
        
        
        let locationSetting: Settings = Settings(name: locationSettingName, isOn: locationIsOn, icon: #imageLiteral(resourceName: "locationServicesIcon"))
        let autoTextSetting: Settings = Settings(name: textingSettingName, isOn: textIsOn, icon: #imageLiteral(resourceName: "autoTextIcon"))
        
        settings = [autoTextSetting, locationSetting]
    }
    
    
    //save
    func saveAsDefault(setting: Settings, value: Bool) {
        
        let userDefaults = UserDefaults.standard
        
        if setting.name == locationSettingName {
            userDefaults.set(value, forKey: locationKey)
        }
        
        if setting.name == textingSettingName {
            userDefaults.set(value, forKey: textKey)
        }
    }
    
    //load
    func getLocationSetting() -> Bool {
        let userDefaults = UserDefaults.standard
        guard let locationDefaultSetting = userDefaults.value(forKey: locationKey) as? Bool else { return false }
        return locationDefaultSetting
    }
    
    func getTextSetting() -> Bool {
        let userDefaults = UserDefaults.standard
        guard let textDefaultSetting = userDefaults.value(forKey: textKey) as? Bool else { return false }
        return textDefaultSetting
    }
}
