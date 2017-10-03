//
//  Selectable.swift
//  Maralog
//
//  Created by Ilias Basha on 10/2/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import Foundation
import UIKit

protocol Selectable {}

extension Selectable where Self: UIButton {
    func customSelect(completion: () -> Void) {
        let inset: CGFloat = 2
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: {
            self.layer.cornerRadius = 0.5 * self.layer.bounds.width
            self.backgroundColor = Keys.sharedInstance.k2
            self.tintColor = .white
            self.transform = CGAffineTransform(scaleX: 1.18, y: 1.18)
            self.imageEdgeInsets = UIEdgeInsetsMake(inset, inset, inset, inset)
        }, completion: nil)
    }
    
    func customDeselect() {
        let inset: CGFloat = 6
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: [], animations: {
            self.backgroundColor = .clear
            self.layer.cornerRadius = 0
            self.tintColor = Keys.sharedInstance.tabBarDefault
            self.transform = CGAffineTransform.identity
            self.imageEdgeInsets = UIEdgeInsetsMake(inset, inset, inset, inset)
        }, completion: nil)
    }

}
