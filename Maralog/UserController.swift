//
//  UserController.swift
//  Maralog
//
//  Created by Ilias Basha on 3/11/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import Foundation

class UserController {
    
    
    static let sharedInstance = UserController()
    
    func saveUserName(name: String?) {
        UserDefaults.standard.set(name, forKey: "name")
    }
    
    func getName() -> String {
        guard let yourName = UserDefaults.standard.value(forKey: "name") as? String else { return "" }
        return yourName
    }
    
}