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
    
    
    
    // app opens on middle tab
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
        
        
        recentlyAddedButton.tintColor = Keys.sharedInstance.tabBarDefault
        addButton.tintColor = Keys.sharedInstance.tabBarDefault
        moreOptionsButton.tintColor = Keys.sharedInstance.tabBarDefault
        
        
        switch index {
        case 0:
            shift(selected: index, current: currentIndex, buttons: buttons)
            self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case 1:
            shift(selected: index, current: currentIndex, buttons: buttons)
            self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        default:
            shift(selected: index, current: currentIndex, buttons: buttons)
            self.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)

        }
        
    }
    
    
    func shift(selected: Int, current: Int, buttons: [UIButton]) {
        
        let currentButton = buttons[current]
        let selectedButton = buttons[selected]
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            selectedButton.layer.transform = CATransform3DMakeScale(1.25, 1.25, 1.25)
            selectedButton.tintColor = Keys.sharedInstance.tabBarSelected
        }, completion: nil)
        
        if current != selected {
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                currentButton.layer.transform = CATransform3DIdentity
                currentButton.tintColor = Keys.sharedInstance.tabBarDefault
            }, completion: nil)
        }
        
    }
    

    
    
    // MARK: - Actions
    @IBAction func didTapButton(_ sender: UIButton) {
        pastPresentIndexes[previous] = pastPresentIndexes[current]
        pastPresentIndexes.updateValue(sender.tag, forKey: current)
        delegate?.tabBarButtonTapped(at: sender.tag)
    }
    
    
}






























