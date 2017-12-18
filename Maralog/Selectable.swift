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


protocol Errorable{}

extension Errorable where Self: UIView {
    func jitter() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint.init(x: self.center.x - 5.0, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint.init(x: self.center.x + 5.0, y: self.center.y))
        layer.add(animation, forKey: "position")
    }
}



