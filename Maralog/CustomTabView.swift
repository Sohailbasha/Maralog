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
    
    
    
    lazy var recentLabel: UILabel = {
        let recentlyAdded = UILabel()
        recentlyAdded.font = UIFont.systemFont(ofSize: 10, weight: UIFontWeightThin)
        recentlyAdded.text = "recents"
        return recentlyAdded
    }()
    
    lazy var addLabel: UILabel = {
        let add = UILabel()
        add.font = UIFont.systemFont(ofSize: 10, weight: UIFontWeightThin)
        add.text = "add"
        return add
    }()
    
    lazy var optionsLabel: UILabel = {
        let options = UILabel()
        options.font = UIFont.systemFont(ofSize: 10, weight: UIFontWeightThin)
        options.text = "options"
        return options
    }()
    
    
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
        
        recentlyAddedButton.tintColor = .white
        addButton.tintColor = .white
        moreOptionsButton.tintColor = .white
        
        
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
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            selectedButton.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        }, completion: nil)
        
        if current != selected {
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                currentButton.layer.transform = CATransform3DIdentity
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






























