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
    
    let locationServiceDescription = "Location Services: Saves when and where you add new contact."
    
    let autoTextDescription = "Auto-Text: Automatically sends a text to your newly added contact."
    
    
    init() {
        let locationIsOn = getLocationSetting()
        let textIsOn = getTextSetting()
        
        let locationSetting: Settings = Settings(name: locationSettingName, isOn: locationIsOn, icon: #imageLiteral(resourceName: "locationServicesIcon"), description: locationServiceDescription)
        let autoTextSetting = Settings(name: textingSettingName, isOn: textIsOn, icon: #imageLiteral(resourceName: "autoTextIcon"), description: autoTextDescription)
        settings = [locationSetting, autoTextSetting]
    }
    
    
    //save
    func saveAsDefault(setting: Settings, value: Bool) {
        
        let userDefaults = UserDefaults.standard
        
        switch setting.name {
        case locationSettingName:
            userDefaults.set(value, forKey: locationKey)
            
        case textingSettingName:
            userDefaults.set(value, forKey: textKey)
            
        default:
            return
        }
//
//        if setting.name == locationSettingName {
//            userDefaults.set(value, forKey: locationKey)
//        }
//
//        if setting.name == textingSettingName {
//            userDefaults.set(value, forKey: textKey)
//        }
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
