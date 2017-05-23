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
        
        let symbol1: Symbols = Symbols(description: "Auto-Text feature. Activating this will generate a message ready to send", icon: #imageLiteral(resourceName: "autoMessage"))
        let symbol2: Symbols = Symbols(description: "Location Services Feature. Activating this will save a time and place to a new contact", icon: #imageLiteral(resourceName: "locationServices"))
    
        let symbol3: Symbols = Symbols(description: "Recently Added. A list of people you've met in the last three days", icon: #imageLiteral(resourceName: "tbRecents"))

        symbols = [symbol1, symbol2, symbol3]
    }
    
    
    
    
    
    
}
