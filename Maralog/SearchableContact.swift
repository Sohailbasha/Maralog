//
//  SearchableContact.swift
//  Maralog
//
//  Created by Ilias Basha on 2/11/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import Foundation

protocol SearchableContact {
    func matchesSearchTerm(with term: String) -> Bool
}
