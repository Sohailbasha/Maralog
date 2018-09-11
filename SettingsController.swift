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
    
    let locationServiceDescription = "Location Services: Saves your general location, and the time when you add a new contact. Must activate before adding a contact."
    
    let autoTextDescription = "Auto-Text: You enter their name/number and Maralog will generate a text for you to send immidiately using the name you've at the start of the app. Must activate before adding a contact."
    
    
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
