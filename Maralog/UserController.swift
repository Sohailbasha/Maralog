import Foundation

class UserController {
    
    static let sharedInstance = UserController()
    
    let kUserName = "userName"
    let kPopUp = "popUpRecieved"
    
    func saveUserName(name: String?) {
        UserDefaults.standard.set(name, forKey: kUserName)
    }
    
    func getName() -> String {
        guard let yourName = UserDefaults.standard.value(forKey: kUserName) as? String else { return "" }
        return yourName
    }
    
    func recieve(popUp: Bool) {
        UserDefaults.standard.set(popUp, forKey: kPopUp)
    }
    
    func didrecievePopUp() -> Bool {
        guard let tOrF = UserDefaults.standard.value(forKey: kPopUp) as? Bool else { return false }
        return tOrF
    }
}
