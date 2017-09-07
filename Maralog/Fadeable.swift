//
//  Fadeable.swift
//  Maralog
//
//  Created by Ilias Basha on 9/7/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

protocol Fadeable {}

extension Fadeable where Self: UIView {
    func fadeIn() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        }
    }
}
