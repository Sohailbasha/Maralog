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
        var locationIsOn = getLocationSetting()
        var textIsOn = getTextSetting()
        
        
        let locationSetting: Settings = Settings(name: locationSettingName, isOn: locationIsOn, icon: #imageLiteral(resourceName: "locationServices"))
        let autoTextSetting: Settings = Settings(name: textingSettingName, isOn: textIsOn, icon: #imageLiteral(resourceName: "autoMessage"))
        
        settings = [locationSetting, autoTextSetting]
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
    
    
    

    func saveToPersistentStorage() {
        let userDefaults = UserDefaults.standard
        let defaultsDictionary = settings.map { $0.dictionaryRep }
        userDefaults.set(defaultsDictionary, forKey: SettingsController.settingsControllerKey)
    }
    
    func loadFromPersistentMemory() {
        let userDefaults = UserDefaults.standard
        guard let defaultsDictionary = userDefaults.object(forKey: SettingsController.settingsControllerKey) as? [[String: Any]] else {return}
        settings = defaultsDictionary.flatMap{ Settings(dictionary: $0) }
    }
}
