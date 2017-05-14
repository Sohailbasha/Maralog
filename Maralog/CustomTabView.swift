//
//  CustomTabView.swift
//  Maralog
//
//  Created by Ilias Basha on 4/15/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit


protocol CustomTabBarViewDelegate: class {
    func tabBarButtonTapped(at index: Int)
}

class CustomTabView: UIView {
    
    override func draw(_ rect: CGRect) {
        menuStack.center = self.center
        options.center = optionsImageView.center
        add.center = addImageView.center
        recent.center = recentlyAddedImageView.center
        
    }

    // MARK: - Outlets + Properties
    @IBOutlet var options: UIButton!
    @IBOutlet var recent: UIButton!
    @IBOutlet var add: UIButton!
    
    @IBOutlet var recentlyAddedImageView: UIImageView!
    @IBOutlet var addImageView: UIImageView!
    @IBOutlet var optionsImageView: UIImageView!
    
    @IBOutlet var menuStack: UIStackView!
    
    
    
    weak var delegate: CustomTabBarViewDelegate?
    
    // app opens on third tab
    var currentIndex: Int {
        guard let previous = pastPresentIndexes[previous] else {
            return 1
        }
        return previous
    }
    
    let previous = "previous"
    let current = "current"
    
    var pastPresentIndexes = ["previous": 0,
                              "current": 1]
    
    
    
    func select(index: Int) {
        
        options.tintColor = .black
        recent.tintColor = .black
        add.tintColor = .black
        
        let buttons: [UIButton] = [options, recent, add]
        
        
        
        switch index {
        case 0:
//            shift(selected: index, current: currentIndex, buttons: buttons)
            recentlyAddedImageView.tintColor = .black


            
            
        case 1:
            
//            shift(selected: index, current: currentIndex, buttons: buttons)
            addImageView.tintColor = .black


        default:
            
//            shift(selected: index, current: currentIndex, buttons: buttons)
//            transitionFrom(currentIndex, to: index, buttons: buttons)
                        optionsImageView.tintColor = .black
            
        }
    }
    
    func shift(selected: Int, current: Int, buttons: [UIButton]) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { 
            buttons[selected].layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        }, completion: nil)
        
        if current != selected {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { 
                buttons[current].layer.transform = CATransform3DIdentity
            }, completion: { (_) in
                
            })
        }
        
    }
    


    
    // MARK: - Actions
    @IBAction func didTapButton(_ sender: UIButton) {
        pastPresentIndexes[previous] = pastPresentIndexes[current]
        pastPresentIndexes.updateValue(sender.tag, forKey: current)
        delegate?.tabBarButtonTapped(at: sender.tag)
    }
    
    
}






























