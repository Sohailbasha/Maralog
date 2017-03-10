//
//  FormattingDate.swift
//  Maralog
//
//  Created by Ilias Basha on 2/10/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import Foundation


class FormattingDate {
    
    static let sharedInstance = FormattingDate()
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter
    } ()
    
}
