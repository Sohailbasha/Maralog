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
    
    init() {
        let locationSetting: Settings = Settings(name: "Location Services", isOn: false, icon: #imageLiteral(resourceName: "locationServices"))
        let autoTextSetting: Settings = Settings(name: "Autotext", isOn: false, icon: #imageLiteral(resourceName: "autoMessage"))
        
        settings = [locationSetting, autoTextSetting]
        loadFromPersistentMemory()
    }
    
    
    func saveLocationSetting(setting: Settings, value: Bool) {
        let userDefaults = UserDefaults.standard
        
        
        
        //userDefaults.set(value, forKey: "locationServiceSetting")
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