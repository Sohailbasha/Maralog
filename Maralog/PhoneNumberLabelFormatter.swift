//
//  PhoneNumberLabelFormatter.swift
//  Maralog
//
//  Created by Ilias Basha on 3/17/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import Foundation

extension String {
    
    var phoneNumberFormatterL: String {
        get {
            var s = self.replacingOccurrences(of: " ", with: "")
            let count = s.characters.count
            if count > 7 {
                s.insert(" ", at: s.index(s.startIndex, offsetBy: 3))
                s.insert(" ", at: s.index(s.startIndex, offsetBy: 7))
            } else if count > 3 {
                s.insert(" ", at: s.index(s.startIndex, offsetBy: 3))
            }
            return s
        }
    }
}
