//
//  SymbolsController.swift
//  Maralog
//
//  Created by Ilias Basha on 5/18/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import Foundation
import UIKit


class SymbolsController {
    static let sharedInstance = SymbolsController()
    
    var symbols: [Symbols] = []
    
    init() {
        let symbol1: Symbols = Symbols(description: "Auto-Text: You enter their name/number and Maralog will generate a text for you to send immidiately using the name you've at the start of the app. Must activate before adding a contact.",
                                       icon: #imageLiteral(resourceName: "autoTextIcon"))
        
        let symbol2: Symbols = Symbols(description: "Location Services: Saves your approximate location, and the time when you add a new contact. Must activate before adding a contact.",
                                       icon: #imageLiteral(resourceName: "locationServicesIcon"))
        
        let symbol3: Symbols = Symbols(description: "Recently Added: A list of contacts you've met in the last 3 days. Contacts in this list also exist in your address book. To delete them from Maralog, simply swipe left on their name.",
                                       icon: #imageLiteral(resourceName: "tbRecentsButton"))

        symbols = [symbol1, symbol2, symbol3]
    }
}
