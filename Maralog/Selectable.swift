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
    func select() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.0, options: [], animations: {
            self.backgroundColor = #colorLiteral(red: 0.9991653562, green: 0.5283692479, blue: 0.591578424, alpha: 1)
            self.setTitleColor(UIColor.white ,for: .normal)
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
    }
    
    func deselect() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.0, options: [], animations: {
            self.backgroundColor = UIColor.white
            self.transform = CGAffineTransform.identity
            self.setTitleColor(Keys.sharedInstance.k2, for: .normal)
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



