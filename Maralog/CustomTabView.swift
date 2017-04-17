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
                              "current": 3]
    
    
    
    
    
    func select(index: Int) {
        
        utilities.tintColor = .black
        recent.tintColor = .black
        contacts.tintColor = .black
        add.tintColor = .black
        
        let buttons: [UIButton] = [utilities, recent, contacts, add]
        
        
        
        switch index {
        case 0:
            transitionFrom(currentIndex, to: index, buttons: buttons)
            //            utilities.tintColor = .blue
            //            recent.tintColor = .black
            //            contacts.tintColor = .black
            //            add.tintColor = .black
            
        case 1:
            transitionFrom(currentIndex, to: index, buttons: buttons)
            //            utilities.tintColor = .black
            //            contacts.tintColor = .black
            //            add.tintColor = .black
            //            recent.tintColor = .blue
            
            
        case 2:
            transitionFrom(currentIndex, to: index, buttons: buttons)
            //            utilities.tintColor = .black
            //            recent.tintColor = .black
            //            add.tintColor = .black
            //            contacts.tintColor = .blue
            
        default:
            transitionFrom(currentIndex, to: index, buttons: buttons)
            //            utilities.tintColor = .black
            //            recent.tintColor = .black
            //            contacts.tintColor = .black
            //            add.tintColor = .blue
        }
    }
    
    func transitionFrom(_ currentIndex: Int, to selectedIndex: Int, buttons: [UIButton]) {
        
        // LEFT TO RIGHT
        if currentIndex < selectedIndex {
            for i in currentIndex...selectedIndex {
                UIView.animate(withDuration: 0.5, animations: {
                    buttons[currentIndex].transform = CGAffineTransform.identity
                }, completion: { (_) in
                    if i != selectedIndex {
                        UIView.animate(withDuration: 0.5, animations: {
                            buttons[i].transform = CGAffineTransform.identity
                        })
                    }
                })
            }
        }
        
        // RIGHT TO LEFT
        if currentIndex > selectedIndex {
            for i in (selectedIndex...currentIndex).reversed() {
                UIView.animate(withDuration: 0.5, animations: {
                    
                    buttons[currentIndex].transform = CGAffineTransform.identity
                    
//                    if i == 3 {
//                        buttons[currentIndex].transform = CGAffineTransform.identity
//                    } else {
//                        buttons[i + 1].transform = CGAffineTransform.identity
//                    }
                    
                }, completion: { (_) in
                    if i != selectedIndex {
                        UIView.animate(withDuration: 0.5, animations: {
                            buttons[i].transform = CGAffineTransform.identity
                        })
                    }
                })
            }
            
        }
    }
    

    
    
    // MARK: - Actions
    @IBAction func didTapButton(_ sender: UIButton) {
        pastPresentIndexes[previous] = pastPresentIndexes[current]
        pastPresentIndexes.updateValue(sender.tag, forKey: current)
        delegate?.tabBarButtonTapped(at: sender.tag)
    }
    
    
}






























