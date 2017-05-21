//
//  UIViewX.swift
//  Maralog
//
//  Created by Ilias Basha on 5/21/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class UIViewX: UIView {

    // MARK: - Gradient

    var firstColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }

    var secondColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    var horizontalGradient: Bool = false {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        guard let layer = self.layer as? CAGradientLayer else { return }
        
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
        if (horizontalGradient) {
            layer.startPoint = CGPoint(x: 0.0, y: 0.5)
            layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 0, y: 1)
        }
    }
    

}
