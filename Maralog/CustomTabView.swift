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
    
    weak var delegate: CustomTabBarViewDelegate?
    
    
    @IBOutlet var recentlyAddedButton: UIButton!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var moreOptionsButton: UIButton!
    
    
    
    
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
        let buttons: [UIButton] = [recentlyAddedButton, addButton, moreOptionsButton]
        
        switch index {
        case 0:
            shift(selected: index, current: currentIndex, buttons: buttons)
        case 1:
            shift(selected: index, current: currentIndex, buttons: buttons)
        default:
            shift(selected: index, current: currentIndex, buttons: buttons)
        }

    }
    
    
    func shift(selected: Int, current: Int, buttons: [UIButton]) {
        
        let currentButton = buttons[current]
        let selectedButton = buttons[selected]
//        let centerY = self.center.y
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            selectedButton.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            self.buttonChange(button: selectedButton)
        }, completion: nil)
        
        if current != selected {
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                currentButton.layer.transform = CATransform3DIdentity
            }, completion: { (_) in
                
            })
        }
        
    }
    
    
    func buttonChange(button: UIButton) {
        switch button {
        case addButton:
            addButton.setImage(#imageLiteral(resourceName: "tbAddS"), for: .normal)
            recentlyAddedButton.setImage(#imageLiteral(resourceName: "tbRecentlyAdded"), for: .normal)
            moreOptionsButton.setImage(#imageLiteral(resourceName: "tbOptions"), for: .normal)
            
        case recentlyAddedButton:
            recentlyAddedButton.setImage(#imageLiteral(resourceName: "tbRecentlyAddedS"), for: .normal)
            addButton.setImage(#imageLiteral(resourceName: "tbAdd"), for: .normal)
            moreOptionsButton.setImage(#imageLiteral(resourceName: "tbOptions"), for: .normal)
            
        default:
            moreOptionsButton.setImage(#imageLiteral(resourceName: "tbOptionsS"), for: .normal)
            addButton.setImage(#imageLiteral(resourceName: "tbAdd"), for: .normal)
            recentlyAddedButton.setImage(#imageLiteral(resourceName: "tbRecentlyAdded"), for: .normal)
        }
    }
    

    
    // MARK: - Actions
    @IBAction func didTapButton(_ sender: UIButton) {
        pastPresentIndexes[previous] = pastPresentIndexes[current]
        pastPresentIndexes.updateValue(sender.tag, forKey: current)
        delegate?.tabBarButtonTapped(at: sender.tag)
    }
    
    
}






























