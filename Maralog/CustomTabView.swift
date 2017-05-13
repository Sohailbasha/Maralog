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
    
    
    
    
    //    override func draw(_ rect: CGRect) {
    //
    //    }
    
    // MARK: - Outlets + Properties
    @IBOutlet var utilities: UIButton!
    @IBOutlet var recent: UIButton!
    @IBOutlet var contacts: UIButton!
    @IBOutlet var add: UIButton!
    
    weak var delegate: CustomTabBarViewDelegate?
    
    // app opens on third tab
    var currentIndex: Int {
        guard let previous = pastPresentIndexes[previous] else {
            return 3
        }
        return previous
    }
    
    let previous = "previous"
    let current = "current"
    
    var pastPresentIndexes = ["previous": 0,
                              "current": 1]
    
    
    
    func select(index: Int) {
        
        utilities.tintColor = .black
        recent.tintColor = .black
        contacts.tintColor = .black
        add.tintColor = .black
        
        let buttons: [UIButton] = [utilities, recent, contacts, add]
        
        
        
        switch index {
        case 0:
            shift(selected: index, current: currentIndex, buttons: buttons)

//            transitionFrom(currentIndex, to: index, buttons: buttons)
            //            utilities.tintColor = .blue
            //            recent.tintColor = .black
            //            contacts.tintColor = .black
            //            add.tintColor = .black
            
            
        case 1:
            
            shift(selected: index, current: currentIndex, buttons: buttons)

//            transitionFrom(currentIndex, to: index, buttons: buttons)
            //            utilities.tintColor = .black
            //            contacts.tintColor = .black
            //            add.tintColor = .black
            //            recent.tintColor = .blue

        default:
            
            shift(selected: index, current: currentIndex, buttons: buttons)
//            transitionFrom(currentIndex, to: index, buttons: buttons)
            //            utilities.tintColor = .black
            //            recent.tintColor = .black
            //            contacts.tintColor = .black
            //            add.tintColor = .blue
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






























