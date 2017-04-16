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
    var currentIndex = 3
    

    
    func select(index: Int) {
        
        utilities.tintColor = .black
        recent.tintColor = .black
        contacts.tintColor = .black
        add.tintColor = .black
        
        let buttons: [UIButton] = [utilities, recent, contacts, add]

        
        
        switch index {
        case 0:
            utilities.tintColor = .blue
            recent.tintColor = .black
            contacts.tintColor = .black
            add.tintColor = .black

        case 1:
            utilities.tintColor = .black
            contacts.tintColor = .black
            add.tintColor = .black
            recent.tintColor = .blue
            
            
        case 2:
            utilities.tintColor = .black
            recent.tintColor = .black
            add.tintColor = .black
            contacts.tintColor = .blue

        default:
            utilities.tintColor = .black
            recent.tintColor = .black
            contacts.tintColor = .black
            add.tintColor = .blue
        }
    }
    
    func transitionFrom(_ currentIndex: Int, to selectedIndex: Int, buttons: [UIButton]) {
        
        for i in currentIndex...selectedIndex {
            
            UIView.animate(withDuration: 0.5, animations: {
            
                buttons[currentIndex].transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                buttons[i].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                
            }, completion: { (_) in
                if i != selectedIndex {
                    
                    buttons[i].transform = CGAffineTransform.identity
                }
            })
        }
        
    }
    
    
    
    // MARK: - Actions
    @IBAction func didTapButton(_ sender: UIButton) {
        delegate?.tabBarButtonTapped(at: sender.tag)
    }
    

}






























